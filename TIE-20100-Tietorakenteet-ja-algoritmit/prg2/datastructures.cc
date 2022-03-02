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
	return allstops_.size();
}

void Datastructures::clear_all()
{
	allstops_.clear();
	allregions_.clear();
	allroutes_.clear();
	allnodes_.clear();
}

std::vector<StopID> Datastructures::all_stops()
{
	std::vector<StopID> stops;
	stops.reserve(allstops_.size());

	std::unordered_map<StopID, Stop>::iterator iter = allstops_.begin();

	while(iter != allstops_.end())
	{
		stops.push_back(iter->first);
		iter++;
	}

	return stops;
}

bool Datastructures::add_stop(StopID id, const Name& name, Coord xy)
{
	// Test if ID already exists
	if(allstops_.find(id) != allstops_.end())
	{
		return false;
	}

	// Create Stop
	auto s = allstops_.insert({id, Stop(id, name, xy)});
	allnodes_.insert({id, StopNode(&(s.first->second))});

	return true;
}

Name Datastructures::get_stop_name(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);

	if(stop == allstops_.end()){
		return NO_NAME;
	}
	return stop->second.name_;
}

Coord Datastructures::get_stop_coord(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);

	if(stop == allstops_.end()){
		return NO_COORD;
	}
	return stop->second.coord_;
}

std::vector<StopID> Datastructures::stops_alphabetically()
{
	// Copy Stops to vector and sort
	std::vector<Stop*> stops;
	stops.reserve(allstops_.size());

	for(auto& s : allstops_){
		stops.push_back(&s.second);
	}

	if(allstops_.size() < 10000){
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
	if(allstops_.size() == 0){
		return NO_STOP;
	}

	Coord origin = {0, 0};

	std::unordered_map<StopID, Stop>::iterator iter = allstops_.begin();

	// Save first stop to compare against
	std::pair<StopID, float> min_stop(iter->first,
									  distance_between_coords(origin, iter->second.coord_));
	iter++;

	while(iter != allstops_.end()){
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
	if(allstops_.size() == 0){
		return NO_STOP;
	}

	Coord origin = {0, 0};

	std::unordered_map<StopID, Stop>::iterator iter = allstops_.begin();

	// Save first stop to compare against
	std::pair<StopID, float> max_stop(iter->first,
									  distance_between_coords(origin, iter->second.coord_));
	iter++;

	while(iter != allstops_.end()){
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

	std::unordered_map<StopID, Stop>::iterator iter = allstops_.begin();

	while(iter != allstops_.end()){
		if(iter->second.name_ == name){
			stops.push_back(iter->first);
		}
		iter++;
	}

	return stops;
}

bool Datastructures::change_stop_name(StopID id, const Name& newname)
{
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);

	if(stop == allstops_.end()){
		return false;
	}

	stop->second.name_ = newname;
	return true;
}

bool Datastructures::change_stop_coord(StopID id, Coord newcoord)
{
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);

	if(stop == allstops_.end()){
		return false;
	}

	stop->second.coord_ = newcoord;
	return true;
}

bool Datastructures::add_region(RegionID id, const Name &name)
{
	// Test if ID already exists
	if(allregions_.find(id) != allregions_.end())
	{
		return false;
	}

	// Create Region
	Region region = Region(id, name);
	allregions_.insert({id, region});

	return true;
}

Name Datastructures::get_region_name(RegionID id)
{
	std::unordered_map<RegionID, Region>::iterator region = allregions_.find(id);

	if(region == allregions_.end()){
		return NO_NAME;
	}

	return region->second.name_;
}

std::vector<RegionID> Datastructures::all_regions()
{
	std::vector<RegionID> regions;
	regions.reserve(allregions_.size());

	std::unordered_map<RegionID, Region>::iterator iter = allregions_.begin();

	while(iter != allregions_.end()){
		regions.push_back(iter->first);
		iter++;
	}

	return regions;
}

bool Datastructures::add_stop_to_region(StopID id, RegionID parentid)
{
	// Test Region validity
	std::unordered_map<RegionID, Region>::iterator region = allregions_.find(parentid);
	if(region == allregions_.end()){
		return false;
	}

	// Test Stop validity
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);
	if(stop == allstops_.end()){
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
	std::unordered_map<RegionID, Region>::iterator parent_region = allregions_.find(parentid);
	if(parent_region == allregions_.end()){
		return false;
	}

	// Test target Region validity
	std::unordered_map<RegionID, Region>::iterator region = allregions_.find(id);
	if(region == allregions_.end()){
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
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);
	if(stop == allstops_.end()){
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
	if(allregions_.find(id) == allregions_.end()){
		return {NO_COORD, NO_COORD};
	}

	std::vector<Stop*> belonging_stops;
	find_stops_in_region(&allregions_.find(id)->second, belonging_stops);

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
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);
	if(stop == allstops_.end()){
		return {NO_STOP};
	}

	std::vector<StopID> stops = stops_distance_to_coord_order(stop->second.coord_);

	int stop_count = std::min((int)(stops.size()), 6);

	std::vector<StopID> r(stops.begin()+1, stops.begin()+stop_count);
	return r;
}

bool Datastructures::remove_stop(StopID id)
{
	std::unordered_map<StopID, Stop>::iterator stop = allstops_.find(id);
	if(stop == allstops_.end()){
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
	allstops_.erase(id);
	allnodes_.erase(id);

	return true;
}

RegionID Datastructures::stops_common_region(StopID id1, StopID id2)
{
	// Test validity
	if(allstops_.find(id1) == allstops_.end() ||
			allstops_.find(id2) == allstops_.end()){
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
	return std::sqrt(std::pow(crd1.x - crd2.x, 2) +
					 std::pow(crd1.y - crd2.y, 2));
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
	stops.reserve(allstops_.size());

	std::unordered_map<StopID, Stop>::iterator iter = allstops_.begin();

	// Calculate distances
	while(iter != allstops_.end()){
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

std::vector<RouteID> Datastructures::all_routes()
{
	std::vector<RouteID> routes;
	routes.reserve(allroutes_.size());

	std::unordered_map<RouteID, Route>::iterator iter = allroutes_.begin();

	while(iter != allroutes_.end()){
		routes.push_back(iter->first);
		iter++;
	}

	return routes;
}

bool Datastructures::add_route(RouteID id, std::vector<StopID> stops)
{   
	// Only one stop in route
	if(stops.size() < 2){
		return false;
	}

	// ID used
	if(allroutes_.find(id) != allroutes_.end()){
		return false;
	}

	// Create and add route
	auto route = allroutes_.insert({id, Route(id)}).first;
	// Assume that this command is successful
	route->second.stops_.reserve(stops.size());
	route->second.trips_.reserve(stops.size());

	StopNode* previous = nullptr;

	// One or more stops not found
	for(StopID &sid : stops){
		auto stopiter = allstops_.find(sid);
		if(stopiter == allstops_.end()){
			return false;
		}
		route->second.stops_.push_back(&(*stopiter).second);

		if(previous != nullptr){
			previous->destinations_.push_back({&(allnodes_.at(sid)), &(route->second)});
		}
		previous = &(allnodes_.at(sid));
	}

	return true;
}

std::vector<std::pair<RouteID, StopID>> Datastructures::routes_from(StopID stopid)
{
	if(allstops_.find(stopid) == allstops_.end()){
		return {{NO_ROUTE, NO_STOP}};
	}

	std::vector<std::pair<RouteID, StopID>> routesout;

	std::unordered_map<RouteID, Route>::iterator iter = allroutes_.begin();

	while(iter != allroutes_.end()){
		std::vector<Stop*> stops = iter->second.stops_;

		for(unsigned int i=0; i<stops.size(); i++){
			if(stops.at(i)->id_ == stopid){
				// If not last stop
				if(i != stops.size()-1){
					routesout.push_back({iter->first, stops.at(i+1)->id_});
				}
			}
		}
		iter++;
	}

	return routesout;
}

std::vector<StopID> Datastructures::route_stops(RouteID id)
{
	auto stopiter = allroutes_.find(id);

	if(stopiter == allroutes_.end()){
		return {NO_STOP};
	}

	std::vector<StopID> stops;

	for(Stop* stop : stopiter->second.stops_){
		stops.push_back(stop->id_);
	}

	return stops;
}

void Datastructures::clear_routes()
{
	allroutes_.clear();
}

std::vector<std::tuple<StopID, RouteID, Distance>>
Datastructures::journey_any(StopID fromstop, StopID tostop)
{
	// ID check
	if(allstops_.find(fromstop) == allstops_.end() || allstops_.find(tostop) == allstops_.end()){
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	StopNode* s = breadth_first_search(fromstop, tostop);
	//StopID id = 0;
	//StopNode* s = depth_first_search(fromstop, tostop, id, false);

	// No route found
	if(s == nullptr){
		reset_nodes();
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	std::vector<std::tuple<StopID, RouteID, Distance>> journey = make_journey(s);
	reset_nodes();
	return journey;
}

std::vector<std::tuple<StopID, RouteID, Distance>>
Datastructures::journey_least_stops(StopID fromstop, StopID tostop)
{
	// ID check
	if(allstops_.find(fromstop) == allstops_.end() || allstops_.find(tostop) == allstops_.end()){
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	StopNode* s = breadth_first_search(fromstop, tostop);

	if(s == nullptr){
		reset_nodes();
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	std::vector<std::tuple<StopID, RouteID, Distance>> journey = make_journey(s);
	reset_nodes();
	return journey;
}

std::vector<std::tuple<StopID, RouteID, Distance>> Datastructures::journey_with_cycle(StopID fromstop)
{
	// ID check
	if(allstops_.find(fromstop) == allstops_.end()){
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	std::vector<std::tuple<StopID, RouteID, Distance>> journey;

	StopID junction = -1;
	StopNode* s = depth_first_search(fromstop, fromstop, junction, true);

	// No route found
	if(s == nullptr){
		reset_nodes();
		return journey;
	}

	journey = make_journey(s);

	// Add junction node to the end

	// Find route leading to the junction node
	StopID stop_id = std::get<0>(journey.back());
	Distance dist = std::get<2>(journey.back());
	auto it = std::find_if(allnodes_.at(stop_id).destinations_.begin(), allnodes_.at(stop_id).destinations_.end(),
						 [junction](const std::pair<StopNode*, Route*> e){ return e.first->stop_->id_ == junction;});
	RouteID route = it->second->id_;

	// Modify RouteID from NO_ROUTE to lead to the junction node
	RouteID& routeid = std::get<1>(journey.back());
	routeid = route;

	// Append junction node
	journey.push_back({junction, NO_ROUTE,
					   dist + distance_between_coords(allstops_.at(stop_id).coord_, allstops_.at(junction).coord_)});

	reset_nodes();
	return journey;
}

std::vector<std::tuple<StopID, RouteID, Distance>> Datastructures::journey_shortest_distance(StopID fromstop, StopID tostop)
{
	// ID check
	if(allstops_.find(fromstop) == allstops_.end() || allstops_.find(tostop) == allstops_.end()){
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	StopNode* s = dijkstra(fromstop, tostop, wRealDistance);

	if(s == nullptr){
		reset_nodes();
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	std::vector<std::tuple<StopID, RouteID, Distance>> journey = make_journey(s);
	reset_nodes();
	return journey;
}

bool Datastructures::add_trip(RouteID routeid, std::vector<Time> const& stop_times)
{
	auto iter = allroutes_.find(routeid);
	if(iter == allroutes_.end()){
		return false;
	}

	iter->second.trips_.push_back(stop_times);

	return true;
}

std::vector<std::pair<Time, Duration>> Datastructures::route_times_from(RouteID routeid, StopID stopid)
{
	auto iter = allroutes_.find(routeid);
	if(iter == allroutes_.end()){
		return {{NO_TIME, NO_DURATION}};
	}

	std::vector<std::pair<Time, Duration>> times;

	Route* route = &(iter->second);
	for(unsigned int i=0;i<route->stops_.size();i++){
		if(route->stops_.at(i)->id_ == stopid){
			// If last stop
			if(i+1 == route->stops_.size()){
				continue;
			}
			for(std::vector<Time> &trip : route->trips_){
				Time time1 = trip.at(i);
				Time time2 = trip.at(i+1);
				times.push_back({time1, time2-time1});
			}
		}
	}

	return times;
}

std::vector<std::tuple<StopID, RouteID, Time>>
Datastructures::journey_earliest_arrival(StopID fromstop, StopID tostop, Time starttime)
{
	// ID check
	if(allstops_.find(fromstop) == allstops_.end() || allstops_.find(tostop) == allstops_.end()){
		return {{NO_STOP, NO_ROUTE, NO_DISTANCE}};
	}

	std::vector<std::tuple<StopID, RouteID, Distance>> journey;

	StopNode* s = dijkstra(fromstop, tostop, wTime, starttime);

	if(s == nullptr){
		reset_nodes();
		return journey;
	}
	if(s->previous_.first != nullptr){
		journey = make_journey(s, true);
	}

	reset_nodes();
	return journey;
}

void Datastructures::add_walking_connections()
{
    // Replace this comment and the line below with your implementation
}

void Datastructures::reset_nodes(){
	std::unordered_map<StopID, StopNode>::iterator iter = allnodes_.begin();

	while(iter != allnodes_.end()){
		iter->second.previous_ = {nullptr, nullptr};
		iter->second.distance_ = INT_MAX;
		iter->second.weigth_ = INT_MAX;
		iter->second.visited_ = 0;
		iter++;
	}
}

std::vector<JourneyPoint> Datastructures::make_journey(StopNode *s, bool earliest_route)
{
	std::vector<std::tuple<StopID, RouteID, Distance>> journey;

	// Step backwards the route
	Route* previous_route = nullptr;	// Route saved in s->previous
	while(true){
		RouteID route = NO_ROUTE;
		Distance distance = s->distance_;

		if(previous_route != nullptr){
			route = previous_route->id_;

			if(earliest_route){
				// Find correct index for time
				int i = 0;
				while(true){
					if(previous_route->stops_.at(i)->id_ ==s->stop_->id_){
						break;
					}
					i++;
				}

				// Pick earliest after arrival, should be correct
				Time earliest_time = INT_MAX;
				Time temp;
				for(std::vector<Time> &trip : previous_route->trips_){
					temp = trip.at(i);
					if(temp >= distance && temp < earliest_time){
						earliest_time = temp;
					}
				}
				distance = earliest_time;
			}
		}

		journey.push_back({s->stop_->id_, route, distance});

		// Final = first stop
		if(s->previous_.first == nullptr){
			break;
		}

		previous_route = s->previous_.second;
		s = s->previous_.first;
	}

	std::reverse(journey.begin(), journey.end());
	return journey;
}

StopNode* Datastructures::breadth_first_search(StopID startat, StopID endat)
{
	std::queue<StopNode*> nodestack;

	StopNode* s = &(allnodes_.at(startat));
	s->visited_ = 1;
	s->distance_ = 0;
	nodestack.push(s);

	while(nodestack.size() != 0){
		StopNode* u = nodestack.front();
		nodestack.pop();

		for(std::pair<StopNode*, Route*> &dest : u->destinations_){
			StopNode* v = dest.first;

			if(v->visited_ == 0){
				v->visited_ = 1;
				Distance dist = distance_between_coords(
							v->stop_->coord_, u->stop_->coord_);
				v->distance_ = u->distance_ + dist;
				v->previous_ = {u, dest.second};
				nodestack.push(v);
			}

			if(v->stop_->id_ == endat){
				return v;
			}
		}
		u->visited_ = 2;
	}

	return nullptr;
}

StopNode* Datastructures::depth_first_search(StopID startat, StopID endat, StopID &junction, bool endatcycle)
{
	std::stack<StopNode*> nodestack;

	StopNode* s = &(allnodes_.at(startat));
	s->distance_ = 0;
	nodestack.push(s);

	while(nodestack.size() != 0){
		StopNode* u = nodestack.top();
		nodestack.pop();

		if(u->visited_ == 0){
			u->visited_ = 1;
			nodestack.push(u);

			for(std::pair<StopNode*, Route*> &dest : u->destinations_){
				StopNode* v = dest.first;

				if(v->visited_ == 0){
					Distance dist = distance_between_coords(
								v->stop_->coord_, u->stop_->coord_);
					v->distance_ = u->distance_ + dist;
					v->previous_ = {u, dest.second};
					nodestack.push(v);
				} else if(v->visited_ == 1){
					if(endatcycle){
						junction = v->stop_->id_;
						return u;
					}
				}
				if(v->stop_->id_ == endat){
					return v;
				}
			}
		} else {
			u->visited_ = 2;
		}
	}

	return nullptr;
}

StopNode* Datastructures::dijkstra(StopID startat, StopID endat, WeightType weighttype, Time starttime)
{
	// Debug
	int visit_count = 0;

	std::queue<StopNode*> nodestack;

	StopNode* s = &(allnodes_.at(startat));
	s->visited_ = 1;
	s->weigth_ = 0;
	s->distance_ = 0;

	if(starttime != -1){
		s->weigth_ = starttime;
		s->distance_ = starttime;
	}
	nodestack.push(s);

	while(nodestack.size() != 0){
		StopNode* u = nodestack.front();
		nodestack.pop();
		visit_count++;

		for(std::pair<StopNode*, Route*> &dest : u->destinations_){
			StopNode* v_stop = dest.first;
			Route* v_route = dest.second;

			// Node needs to be evaluated if not visited
			if(v_stop->visited_ == 0){
				v_stop->visited_ = 1;
				nodestack.push(v_stop);
			}

			// Use arrival time
			// NOTE: this is not exactly what route_earliest_arrive wants
			if(weighttype == wTime){
				// Find earliest leave >u.distance_ in dest.trips
				Time earliest = INT_MAX;		// Earliest leave from u
				Time earliest_next = INT_MAX;	// Earliest arrival on v

				for(std::vector<Time> &trip : v_route->trips_){
					// Find correct index for the stop
					for(unsigned int i=0; i<trip.size(); i++){
						if(v_route->stops_.at(i)->id_ == u->stop_->id_){

							// Time when trip leaves u
							Time time = trip.at(i);

							if(time >= u->weigth_ && time <= earliest){
								earliest = time;
								earliest_next = trip.at(i+1);
							}
							// u cant be in the trip twice
							break;
						}
					}
				}

				if(v_stop->weigth_ > earliest_next){
					v_stop->weigth_ = earliest_next;
					v_stop->distance_ = earliest_next;
					v_stop->previous_ = {u, v_route};

					// The stop was reached earlier so it needs to be re-evaluated
					if(weighttype == wTime){
						nodestack.push(v_stop);
					}
				}
			} else {
			// wDistance & wRealDistance
				Distance weight = INT_MAX;
				Distance distance = distance_between_coords(
								v_stop->stop_->coord_, u->stop_->coord_);

				// Use stop count distance
				if(weighttype == wDistance){
					weight = 1;
				}

				// Use physical distance
				if(weighttype == wRealDistance){
					weight = distance;
				}

				if(v_stop->weigth_ > u->weigth_ + weight){
					v_stop->weigth_ = u->weigth_ + weight;
					v_stop->distance_ = u->distance_ + distance;
					v_stop->previous_ = {u, v_route};
				}
			}
		}
		u->visited_ = 2;
	}

	//qDebug() << "Nodes visited: " << visit_count;
	if(allnodes_.at(endat).visited_ > 0){
		return &(allnodes_.at(endat));
	}
	return nullptr;
}

void Datastructures::print_nodes()
{
	for(auto &node : allnodes_){
		StopNode* previous = node.second.previous_.first;
		if(previous != nullptr){
			//qDebug() << "ID: " << node.second.stop_->id_ << " -> " << previous->stop_->id_;
		} else {
			//qDebug() << "ID: " << node.second.stop_->id_ << " -> " << "nullptr";
		}
	}
}
