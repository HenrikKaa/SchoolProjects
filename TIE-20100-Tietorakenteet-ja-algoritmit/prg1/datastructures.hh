// Datastructures.hh

#ifndef DATASTRUCTURES_HH
#define DATASTRUCTURES_HH

#include <string>
#include <vector>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <set>
#include <utility>
#include <limits>
#include <algorithm>
#include <climits>
#include <iterator>

// Types for IDs
using StopID = long int;
using RegionID = std::string;
using Name = std::string;

// Return values for cases where required thing was not found
StopID const NO_STOP = -1;
RegionID const NO_REGION = "!!NO_REGION!!";

// Return value for cases where integer values were not found
int const NO_VALUE = std::numeric_limits<int>::min();

// Return value for cases where name values were not found
Name const NO_NAME = "!!NO_NAME!!";

// Type for a coordinate (x, y)
struct Coord
{
    int x = NO_VALUE;
    int y = NO_VALUE;
};

// Example: Defining == and hash function for Coord so that it can be used
// as key for std::unordered_map/set, if needed
inline bool operator==(Coord c1, Coord c2) { return c1.x == c2.x && c1.y == c2.y; }
inline bool operator!=(Coord c1, Coord c2) { return !(c1==c2); } // Not strictly necessary

// Example: Defining < for Coord so that it can be used
// as key for std::map/set
inline bool operator<(Coord c1, Coord c2)
{
    if (c1.y < c2.y) { return true; }
    else if (c2.y < c1.y) { return false; }
    else { return c1.x < c2.x; }
}

// Return value for cases where coordinates were not found
Coord const NO_COORD = {NO_VALUE, NO_VALUE};

struct Stop;

// Struct for region data
struct Region
{
    RegionID id_;
    Name name_;
	std::vector<Stop*> childrenStops_;
    Region* parentRegion_ = nullptr;
	std::vector<Region*> childrenRegions_;

    Region(RegionID id, Name name) :
        id_(id), name_(name) {}
};

// Struct for stop data
struct Stop
{
    StopID id_;
    Name name_;
    Coord coord_;
    Region* region_ = nullptr;

    Stop(StopID id, Name name, Coord coord) :
        id_(id), name_(name), coord_(coord) {}
};

// This is the class you are supposed to implement

class Datastructures
{
public:
    Datastructures();
    ~Datastructures();

    // Estimate of performance: Θ(1)
    // Short rationale for estimate: cpp doc
    int stop_count();

    // Estimate of performance: Θ(n)
	// Short rationale for estimate: cpp doc, every object is removed on its own
    void clear_all();

    // Estimate of performance: Θ(n)
    // Short rationale for estimate: Every StopID is read once
    std::vector<StopID> all_stops();

	// Estimate of performance: O(1)
	// Short rationale for estimate: Finding if id exists and adding the stop both are Θ(1)
    bool add_stop(StopID id, Name const& name, Coord xy);

	// Estimate of performance: O(1)
	// Short rationale for estimate: Finding the stop is Θ(1)
    Name get_stop_name(StopID id);

	// Estimate of performance: O(1)
	// Short rationale for estimate: Finding the stop is Θ(1)
    Coord get_stop_coord(StopID id);

    // We recommend you implement the operations below only after implementing the ones above

    // Estimate of performance: Θ(n*log(n))
    // Short rationale for estimate: Sorting is done with std::sort n*log(n)
    std::vector<StopID> stops_alphabetically();

    // Estimate of performance: Θ(n*log(n))
    // Short rationale for estimate: Sorting is done with std::sort n*log(n)
    std::vector<StopID> stops_coord_order();

    // Estimate of performance: Θ(n)
    // Short rationale for estimate: Every stop's coordinates are read and compared once
    StopID min_coord();

    // Estimate of performance: Θ(n)
    // Short rationale for estimate: Every stop's coordinates are read and compared once
    StopID max_coord();

    // Estimate of performance: Θ(n)
    // Short rationale for estimate: The name of each stop is read once
    std::vector<StopID> find_stops(Name const& name);

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Finding the stop Θ(1), changing the name Θ(1)
    bool change_stop_name(StopID id, Name const& newname);

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Finding the stop Θ(1), changing the coordinate Θ(1)
    bool change_stop_coord(StopID id, Coord newcoord);

    // We recommend you implement the operations below only after implementing the ones above

	// Estimate of performance: Θ(1)
    // Short rationale for estimate:
	// Finding if id exists and adding the region both are Θ(1)
    bool add_region(RegionID id, Name const& name);

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Finding the region Θ(1)
    Name get_region_name(RegionID id);

	// Estimate of performance: Θ(n)
    // Short rationale for estimate: Reading each Region Θ(n) and adding them to vector Θ(n)
    std::vector<RegionID> all_regions();

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Finding the stop and the region are Θ(1)
    bool add_stop_to_region(StopID id, RegionID parentid);

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Finding the stop and the region are Θ(1)
    bool add_subregion_to_region(RegionID id, RegionID parentid);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Finding the stop Θ(1). Finding all the parent regions Θ(n)
    std::vector<RegionID> stop_regions(StopID id);

    // Non-compulsory operations

    // Estimate of performance:
    // Short rationale for estimate:
    void creation_finished();

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Finding the region Θ(1). The function collects all stops from specified id
	// and its children.
    std::pair<Coord, Coord> region_bounding_box(RegionID id);

	// Estimate of performance: Θ(n*log(n))
	// Short rationale for estimate: Finding the stop Θ(1). Stops are sorted with stops_distance_to_coord_order()
	// which is n*log(n). Resizing vector Θ(n)
    std::vector<StopID> stops_closest_to(StopID id);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Finding the stop is Θ(1). Finding the stop from a Region Θ(n)
    bool remove_stop(StopID id);

	// Estimate of performance: Θ(n^2)
	// Short rationale for estimate: Finding Stops Θ(1). Finding all Regions of Stops is Θ(n).
    // Finding if certain stop exists in the other stop's (id2) regions requires looping through all
    // regions of both stops
    RegionID stops_common_region(StopID id1, StopID id2);

private:
    // Calculate Euclidean distance between two Coords
    float distance_between_coords(Coord crd1, Coord crd2);

    // Sort by pair.first and then Stop.Coord.y
    static bool sort_distance(std::pair<float, Stop*> s1, std::pair<float, Stop*> s2);

    // Sort by Stop.name_
	static bool sort_names(Stop* s1, Stop* s2);

	// Estimate of performance: Θ(n*log(n))
	// Short rationale for estimate: Uses radix and std::sort mix to sort the stops. Radix shortens the
	// process time but after dividing the stops to buckets final sorting is done with std::sort which
	// is n*log(n)
	std::vector<Stop*> sort_alphabetical(std::vector<Stop*>& stops, int index=0);

	// Estimate of performance: Θ(n*log(n))
    // Short rationale for estimate: Sorting is done with std::sort n*log(n)
    // Get all stops sorted by distance to defined Coord
    std::vector<StopID> stops_distance_to_coord_order(Coord crd);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Finds subregions recursively. Each region is visited only once
	void find_subregions(Region* region, std::unordered_set<Region*>& regions);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Finds all stops of the region and all of its subregions. Each region
	// and stop is visited only once
	void find_stops_in_region(Region* region, std::vector<Stop*>& stops);

    // Data
	std::unordered_map<StopID, Stop> stops_;
	std::unordered_map<RegionID, Region> regions_;
};

#endif // DATASTRUCTURES_HH
