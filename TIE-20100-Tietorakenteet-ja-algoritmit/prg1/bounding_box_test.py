import random
import sys
import math

def main(stop_count):
    stopID = 0

    f = open("bounding_test.txt", 'w')

    # Clear
    f.write("clear_all\n")

    # Regions
    region_count = int(int(stop_count)/50)
    print(region_count)
    for i in range(0, region_count):
        f.write(add_region(i, int(stop_count)))

        if i > 5:
            parent = random.randrange(0, i)
            f.write(add_subregion_to_region(i, parent))

    # Stops
    for i in range(0, int(stop_count)):
        f.write(add_stop(i))
        region = random.randrange(0, region_count)
        f.write(add_stop_to_region(i, region))

    # Timer
    for i in range(0, 5):
        f.write("stopwatch next\n")
        f.write("region_bounding_box {}\n".format(i))
    f.close()

def add_stop(id):
    x = random.randrange(0, 500)
    y = random.randrange(0,500)
    return "add_stop {} {} ({},{})\n".format(id, id, x, y)

def add_region(id, count):
    return "add_region {} {}\n".format(id, id)

def add_stop_to_region(stop_id, region_id):
    return "add_stop_to_region {} {}\n".format(stop_id, region_id)

def add_subregion_to_region(id1, id2):
    return "add_subregion_to_region {} {}\n".format(id1, id2)

if __name__ == "__main__":
    a = sys.argv[1]
    main(a)