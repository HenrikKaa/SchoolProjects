// Datastructures.hh

#ifndef DATASTRUCTURES_HH
#define DATASTRUCTURES_HH

#include <string>
#include <vector>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <set>
#include <queue>
#include <stack>
#include <utility>
#include <limits>
#include <algorithm>
#include <climits>
#include <iterator>
//#include <qdebug>

// Types for IDs
using StopID = long int;
using RegionID = std::string;
using RouteID = std::string;
using Name = std::string;

// Return values for cases where required thing was not found
RouteID const NO_ROUTE = "!!NO_ROUTE!!";
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

// Type for time of day in minutes from midnight (i.e., 60*hours + minutes)
using Time = int;

// Return value for cases where color was not found
Time const NO_TIME = std::numeric_limits<Time>::min();

// Type for a duration of time (in minutes)
using Duration = int;

// Return value for cases where Duration is unknown
Duration const NO_DURATION = NO_VALUE;

// Type for a distance (in metres)
using Distance = int;

// Return value for cases where Duration is unknown
Distance const NO_DISTANCE = NO_VALUE;

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

// Struct for trips
/*struct Trip
{
	std::vector<Time> times_;

	Trip(std::vector<Time> times) :
		times_(times) {}
};*/

// Struct for routes
struct Route
{
	RouteID id_;
	std::vector<Stop*> stops_;
	std::vector<std::vector<Time>> trips_;

	Route(RouteID id) :
		id_(id) {}
};

// Stop struct for journey calculations
struct StopNode
{
	Stop* stop_;
	Distance distance_ = INT_MAX;
	Distance weigth_ = INT_MAX;
	std::vector<std::pair<StopNode*, Route*>> destinations_;
	std::pair<StopNode*, Route*> previous_;
	int visited_ = 0;

	StopNode(Stop* stop) :
		stop_(stop) {}
};

// Shorthand for journeys
using JourneyPoint = std::tuple<StopID, RouteID, Distance>;

// Dijkstra weight type
enum WeightType { wDistance, wRealDistance, wTime};

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

	////////////////////////////////////////
	// Phase 2 operations				  //
	////////////////////////////////////////

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Each route is iterated once and added Θ(1) to vector
    std::vector<RouteID> all_routes();

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Checking and creating the route is Θ(1) but each
	// StopID has to be checked. Complexity is linear in amount of stops
    bool add_route(RouteID id, std::vector<StopID> stops);

	// Estimate of performance: ~Θ(n^2)
	// Short rationale for estimate: Every route and every stop of route is iterated. More accurately
	// complexity is amount of routes times average amount of stops in routes
    std::vector<std::pair<RouteID, StopID>> routes_from(StopID stopid);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Every stop is iterated and its ID saved
    std::vector<StopID> route_stops(RouteID id);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: cpp doc, every object is removed on its own
    void clear_routes();

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: This function uses BFS algorithm which has linear complexity.
	// Also make_journey is called that is also a linear operation
    std::vector<std::tuple<StopID, RouteID, Distance>> journey_any(StopID fromstop, StopID tostop);

//    // Non-compulsory operations

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: BFS algorithm
    std::vector<std::tuple<StopID, RouteID, Distance>> journey_least_stops(StopID fromstop, StopID tostop);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: DFS algorithm
    std::vector<std::tuple<StopID, RouteID, Distance>> journey_with_cycle(StopID fromstop);

	// Estimate of performance: Θ(nlogn)
	// Short rationale for estimate: Uses Dijkstra's algorithm. See dijkstra() for complexity.
    std::vector<std::tuple<StopID, RouteID, Distance>> journey_shortest_distance(StopID fromstop, StopID tostop);

	// Estimate of performance: Θ(1)
	// Short rationale for estimate: Vector can be directly copied to specified route so no
	// linear operations are needed
    bool add_trip(RouteID routeid, const std::vector<Time> &stop_times);

	// Estimate of performance: Θ(n^2)
	// Short rationale for estimate: Each stop in routes has to be iterated
	std::vector<std::pair<Time, Duration>> route_times_from(RouteID routeid, StopID stopid);

	// Estimate of performance: Θ(nlogn) or something more
	// Short rationale for estimate: Uses Dijkstra's algorithm. See dijkstra() for complexity.
    std::vector<std::tuple<StopID, RouteID, Time>> journey_earliest_arrival(StopID fromstop, StopID tostop, Time starttime);

    // Estimate of performance:
    // Short rationale for estimate:
    void add_walking_connections(); // Note! This method is completely optional, and not part of any testing

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

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Iterates all nodes
	void reset_nodes();

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Linear complexity in journey length. In reality doesn't get slower that
	// fast because adding stops doesn't make every journey longer
	std::vector<JourneyPoint> make_journey(StopNode* s, bool earliest_route=false);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Implementation of pseudocode found in lecture material. The complexity is
	// sum of edges and nodes
	StopNode* breadth_first_search(StopID startat, StopID endat);

	// Estimate of performance: Θ(n)
	// Short rationale for estimate: Implementation of pseudocode found in lecture material. The complexity is
	// sum of edges and nodes
	StopNode* depth_first_search(StopID startat, StopID endat, StopID &junction, bool endatcycle=false);

	// Estimate of performance: Θ(nlogn) when not looking for earliest arrival
	// Short rationale for estimate: Implementation of pseudocode found in lecture material. Complexity is
	// sum of edges and nodes times log of nodes. When calculating earliest arrival, some already discovered
	// nodes that can be reached earlier will have to be recalculated and processing time becomes significantly
	// longer but it is hard to estimate by how much.
	StopNode* dijkstra(StopID startat, StopID endat, WeightType weighttype=wRealDistance, Time starttime=-1);

	// Debug
	void print_nodes();

	// Data
	std::unordered_map<StopID, Stop> allstops_;
	std::unordered_map<RegionID, Region> allregions_;
	std::unordered_map<RouteID, Route> allroutes_;

	std::unordered_map<StopID, StopNode> allnodes_;

};

#endif // DATASTRUCTURES_HH
