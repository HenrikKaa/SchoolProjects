// Datastructures.cc

#include "datastructures.hh"

#include <random>
#include <cmath>
#include <stdexcept>
#include <iostream>

std::minstd_rand rand_engine; // Reasonably quick pseudo-random generator

template <typename Type>
Type random_in_range(Type start, Type end)
{
	auto range = end-start;
	++range;

	auto num = std::uniform_int_distribution<unsigned long int>(0, range-1)(rand_engine);

	return static_cast<Type>(start+num);
}

// Modify the code below to implement the functionality of the class.
// Also remove comments from the parameter names when you implement
// an operation (Commenting out parameter name prevents compiler from
// warning about unused parameters on operations you haven't yet implemented.)

Datastructures::Datastructures()
{
	// Replace this comment with your implementation
}

Datastructures::~Datastructures()
{
	clear_all();
}

int Datastructures::stop_count()
{
	return stops_.size();
}

void Datastructures::clear_all()
{
	stops_.clear();
	regions_.clear();
}

std::vector<StopID> Datastructures::all_stops()
{
	std::vector<StopID> stops;
	stops.reserve(stops_.size());

	std::unordered_map<StopID, Stop>::iterator iter = stops_.begin();

	while(iter != stops_.end())
	{
		stops.push_back(iter->first);
		iter++;
	}

	return stops;
}

bool Datastructures::add_stop(StopID id, const Name& name, Coord xy)
{
	// Test if ID already exists
	if(stops_.find(id) != stops_.end())
	{
		return false;
	}

	// Create Stop
	stops_.insert({id, Stop(id, name, xy)});

	return true;
}

Name Datastructures::get_stop_name(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);

	if(stop == stops_.end()){
		return NO_NAME;
	}
	return stop->second.name_;
}

Coord Datastructures::get_stop_coord(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);

	if(stop == stops_.end()){
		return NO_COORD;
	}
	return stop->second.coord_;
}

std::vector<StopID> Datastructures::stops_alphabetically()
{
	// Copy Stops to vector and sort
	std::vector<Stop*> stops;
	stops.reserve(stops_.size());

	for(auto& s : stops_){
		stops.push_back(&s.second);
	}

	if(stops_.size() < 10000){
		std::sort(stops.begin(), stops.end(), sort_names);
	} else {
		stops = sort_alphabetical(stops);
	}

	// Adding all Stops to vector is O(n)
	std::vector<StopID> stops_id;
	stops_id.reserve(stops.size());

	for(auto& s : stops){
		stops_id.push_back(s->id_);
	}

	return stops_id;
}

std::vector<StopID> Datastructures::stops_coord_order()
{
	Coord origin = {0, 0};

	return stops_distance_to_coord_order(origin);
}

StopID Datastructures::min_coord()
{
	if(stops_.size() == 0){
		return NO_STOP;
	}

	Coord origin = {0, 0};

	std::unordered_map<StopID, Stop>::iterator iter = stops_.begin();

	// Save first stop to compare against
	std::pair<StopID, float> min_stop(iter->first,
									  distance_between_coords(origin, iter->second.coord_));
	iter++;

	while(iter != stops_.end()){
		float distance = distance_between_coords(origin, iter->second.coord_);

		if( min_stop.second > distance){
			min_stop = {iter->first, distance};
		}
		iter++;
	}

	return min_stop.first;
}

StopID Datastructures::max_coord()
{
	if(stops_.size() == 0){
		return NO_STOP;
	}

	Coord origin = {0, 0};

	std::unordered_map<StopID, Stop>::iterator iter = stops_.begin();

	// Save first stop to compare against
	std::pair<StopID, float> max_stop(iter->first,
									  distance_between_coords(origin, iter->second.coord_));
	iter++;

	while(iter != stops_.end()){
		float distance = distance_between_coords(origin, iter->second.coord_);

		if( max_stop.second < distance){
			max_stop = {iter->first, distance};
		}
		iter++;
	}

	return max_stop.first;
}

std::vector<StopID> Datastructures::find_stops(Name const& name)
{
	std::vector<StopID> stops;

	std::unordered_map<StopID, Stop>::iterator iter = stops_.begin();

	while(iter != stops_.end()){
		if(iter->second.name_ == name){
			stops.push_back(iter->first);
		}
		iter++;
	}

	return stops;
}

bool Datastructures::change_stop_name(StopID id, const Name& newname)
{
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);

	if(stop == stops_.end()){
		return false;
	}

	stop->second.name_ = newname;
	return true;
}

bool Datastructures::change_stop_coord(StopID id, Coord newcoord)
{
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);

	if(stop == stops_.end()){
		return false;
	}

	stop->second.coord_ = newcoord;
	return true;
}

bool Datastructures::add_region(RegionID id, const Name &name)
{
	// Test if ID already exists
	if(regions_.find(id) != regions_.end())
	{
		return false;
	}

	// Create Region
	Region region = Region(id, name);
	regions_.insert({id, region});

	return true;
}

Name Datastructures::get_region_name(RegionID id)
{
	std::unordered_map<RegionID, Region>::iterator region = regions_.find(id);

	if(region == regions_.end()){
		return NO_NAME;
	}

	return region->second.name_;
}

std::vector<RegionID> Datastructures::all_regions()
{
	std::vector<RegionID> regions;
	regions.reserve(regions_.size());

	std::unordered_map<RegionID, Region>::iterator iter = regions_.begin();

	while(iter != regions_.end()){
		regions.push_back(iter->first);
		iter++;
	}

	return regions;
}

bool Datastructures::add_stop_to_region(StopID id, RegionID parentid)
{
	// Test Region validity
	std::unordered_map<RegionID, Region>::iterator region = regions_.find(parentid);
	if(region == regions_.end()){
		return false;
	}

	// Test Stop validity
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);
	if(stop == stops_.end()){
		return false;
	}
	if(stop->second.region_ != nullptr){
		return false;
	}

	stop->second.region_ = &region->second;
	region->second.childrenStops_.push_back(&stop->second);

	return true;
}

bool Datastructures::add_subregion_to_region(RegionID id, RegionID parentid)
{
	// Test parent Region validity
	std::unordered_map<RegionID, Region>::iterator parent_region = regions_.find(parentid);
	if(parent_region == regions_.end()){
		return false;
	}

	// Test target Region validity
	std::unordered_map<RegionID, Region>::iterator region = regions_.find(id);
	if(region == regions_.end()){
		return false;
	}
	if(region->second.parentRegion_ != nullptr){
		return false;
	}

	region->second.parentRegion_ = &parent_region->second;
	parent_region->second.childrenRegions_.push_back(&region->second);

	return true;
}

std::vector<RegionID> Datastructures::stop_regions(StopID id)
{
	// Test Stop validity
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);
	if(stop == stops_.end()){
		return {NO_REGION};
	}

	// Regions in which Stop belongs
	std::vector<RegionID> regions;

	// Current iteration
	Region* reg = stop->second.region_;

	if(reg == nullptr){
		return regions;
	}
	regions.push_back(reg->id_);

	// Add all parent Regions
	while(reg->parentRegion_ != nullptr){
		regions.push_back(reg->parentRegion_->id_);
		reg = reg->parentRegion_;
	}

	return regions;

}

void Datastructures::creation_finished()
{

}

std::pair<Coord,Coord> Datastructures::region_bounding_box(RegionID id)
{
	// Test validity
	if(regions_.find(id) == regions_.end()){
		return {NO_COORD, NO_COORD};
	}

	std::vector<Stop*> belonging_stops;
	find_stops_in_region(&regions_.find(id)->second, belonging_stops);

	Coord coord_min = {INT_MAX, INT_MAX};
	Coord coord_max = {INT_MIN, INT_MIN};

	for(Stop* stop : belonging_stops){
		// Update min and max
		coord_min.x = std::min(coord_min.x, stop->coord_.x);
		coord_min.y = std::min(coord_min.y, stop->coord_.y);

		coord_max.x = std::max(coord_max.x, stop->coord_.x);
		coord_max.y = std::max(coord_max.y, stop->coord_.y);
	}

	if(belonging_stops.size() != 0){ return {coord_min, coord_max }; }
	else {return { NO_COORD, NO_COORD }; }
}

std::vector<StopID> Datastructures::stops_closest_to(StopID id)
{
	// Test Stop validity
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);
	if(stop == stops_.end()){
		return {NO_STOP};
	}

	std::vector<StopID> stops = stops_distance_to_coord_order(stop->second.coord_);

	int stop_count = std::min((int)(stops.size()), 6);

	std::vector<StopID> r(stops.begin()+1, stops.begin()+stop_count);
	return r;
}

bool Datastructures::remove_stop(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = stops_.find(id);
	if(stop == stops_.end()){
		return false;
	}

	Region* parent_region = stop->second.region_;

	if(parent_region != nullptr){
		for(unsigned int i=0; i<parent_region->childrenStops_.size(); i++){
			if(parent_region->childrenStops_.at(i)->id_ == id){
				parent_region->childrenStops_.erase(
							parent_region->childrenStops_.begin()+i);
				break;
			}
		}
	}

	//delete stop->second;
	stops_.erase(stop);

	return true;
}

RegionID Datastructures::stops_common_region(StopID id1, StopID id2)
{
	// Test validity
	if(stops_.find(id1) == stops_.end() ||
			stops_.find(id2) == stops_.end()){
		return NO_REGION;
	}

	// Temporary vectors for the Regions of id1 and id2
	std::vector<RegionID> r1 = stop_regions(id1);
	std::vector<RegionID> r2 = stop_regions(id2);

	std::vector<RegionID>::iterator iter = r1.begin();

	while(iter != r1.end()){
		if(std::find(r2.begin(), r2.end(), *iter) != r2.end()){
			return *iter;
		}
		iter++;
	}

	return NO_REGION;
}

float Datastructures::distance_between_coords(Coord crd1, Coord crd2)
{
	return std::pow(crd1.x - crd2.x, 2) +
					 std::pow(crd1.y - crd2.y, 2);
}

bool Datastructures::sort_distance(std::pair<float, Stop*> s1, std::pair<float, Stop*> s2)
{
	if(s1.first < s2.first){
		return true;
	}
	else if(s1.first == s2.first){
		if(s1.second->coord_.y < s2.second->coord_.y){
			return true;
		}
	}
	else{
		return false;
	}
	return false;
}

bool Datastructures::sort_names(Stop* s1, Stop* s2)
{
	return s1->name_ < s2->name_;
}

std::vector<Stop*> Datastructures::sort_alphabetical(std::vector<Stop*>& stops, int index)
{
	std::vector<Stop*> returnvec(stops.size());

	std::array<std::vector<Stop*>, 27> buckets;
	std::fill(buckets.begin(), buckets.end(), std::vector<Stop*>());

	// Estimation of required space
	for(auto& b : buckets){
		b.reserve(stops.size()/20);
	}

	for(auto& s : stops){
		int target = 0;

		for(int i=index; i >= 0; i--){
			if(s->name_.size() > static_cast<unsigned int>(i)){
				target = s->name_.at(i);
				break;
			}
		}

		// Numbers, spaces and dashes
		if((target >= 48 && target <= 57) || target == 32 || target == 45){
			buckets[0].push_back(s);
		}
		else{
			if(target > 90){
				target -= 32;
			}
			buckets[target-64].push_back(s);}
	}

	int insert_point = 0;
	for(unsigned int i=0; i<buckets.size(); i++){
		if(index <= 1){
			buckets.at(i) = sort_alphabetical(buckets.at(i), index+1);
		} else{
			std::sort(buckets[i].begin(), buckets[i].end(), sort_names);
		}

		std::move(buckets[i].begin(),
				  buckets[i].end(),
				  returnvec.begin()+insert_point);
		insert_point += buckets.at(i).size();
	}

	return returnvec;
}

std::vector<StopID> Datastructures::stops_distance_to_coord_order(Coord crd)
{
	std::vector<std::pair<float, Stop*>> stops;
	stops.reserve(stops_.size());

	std::unordered_map<StopID, Stop>::iterator iter = stops_.begin();

	// Calculate distances
	while(iter != stops_.end()){
		float distance = distance_between_coords(iter->second.coord_, crd);
		stops.push_back(std::make_pair(distance, &iter->second));
		iter++;
	}

	std::sort(stops.begin(), stops.end(), sort_distance);

	// Create StopID vector
	std::vector<StopID> stops_vec;
	std::vector<std::pair<float, Stop*>>::iterator iterm = stops.begin();

	while(iterm != stops.end()){
		stops_vec.push_back(iterm->second->id_);
		iterm++;
	}

	return stops_vec;
}

void Datastructures::find_subregions(Region* region, std::unordered_set<Region*> &regions)
{
	regions.insert(region);
	for(auto r : region->childrenRegions_){
		find_subregions(r, regions);
	}
}

void Datastructures::find_stops_in_region(Region* region, std::vector<Stop*>& stops)
{
	for(Stop* s : region->childrenStops_){
		stops.push_back(s);
	}
	for(Region* r : region->childrenRegions_){
		find_stops_in_region(r, stops);
	}
}
