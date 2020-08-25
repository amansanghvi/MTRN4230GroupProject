#!/usr/bin/env python

import rospy, tf
from gazebo_msgs.srv import DeleteModel, SpawnModel
from geometry_msgs.msg import *
import os
import random as rand

simulation_models_path = '/home/javad/simulation_ws/src/ur5_t2_4230/models'
if __name__ == '__main__':
    print("Waiting for gazebo services...")
    rospy.init_node("spawn_products_in_bins")
    rospy.wait_for_service("gazebo/delete_model")
    rospy.wait_for_service("gazebo/spawn_sdf_model")
    print("Got it.")
    delete_model = rospy.ServiceProxy("gazebo/delete_model", DeleteModel)
    spawn_model = rospy.ServiceProxy("gazebo/spawn_sdf_model", SpawnModel)

    with open(simulation_models_path + "/cylinder_pill_blue/model.sdf", "r") as f:
        blue_cylinder_xml = f.read()
    
    with open(simulation_models_path + "/cylinder_pill_green/model.sdf", "r") as f:
        green_cylinder_xml = f.read()

    with open(simulation_models_path + "/cylinder_pill_red/model.sdf", "r") as f:
        red_cylinder_xml = f.read()

    with open(simulation_models_path + "/pentagon_pill_blue/model.sdf", "r") as f:
        blue_pentagon_xml = f.read()
    
    with open(simulation_models_path + "/pentagon_pill_green/model.sdf", "r") as f:
        green_pentagon_xml = f.read()
    
    with open(simulation_models_path + "/pentagon_pill_red/model.sdf", "r") as f:
        red_pentagon_xml = f.read()
    
    with open(simulation_models_path + "/square_pill_blue/model.sdf", "r") as f:
        blue_square_xml = f.read()

    with open(simulation_models_path + "/square_pill_green/model.sdf", "r") as f:
        green_square_xml = f.read()
    
    with open(simulation_models_path + "/square_pill_red/model.sdf", "r") as f:
        red_square_xml = f.read()

    with open(simulation_models_path + "/triangle_pill_blue/model.sdf", "r") as f:
        blue_triangle_xml = f.read()
    
    with open(simulation_models_path + "/triangle_pill_green/model.sdf", "r") as f:
        green_triangle_xml = f.read()
    
    with open(simulation_models_path + "/triangle_pill_red/model.sdf", "r") as f:
        red_triangle_xml = f.read()

    # Array to hold shape values
    shape_vector = [blue_cylinder_xml, green_cylinder_xml, red_cylinder_xml,\
                    blue_pentagon_xml, green_pentagon_xml, red_pentagon_xml,\
                    blue_square_xml,   green_square_xml,   red_square_xml,\
                    blue_triangle_xml, green_triangle_xml, red_triangle_xml]

    #Create 2D grid of Shape Centres
    #Each centre is randomly offset to provide pseudo random placements
    num_cols = 5
    num_rows = 5
    zone_width = 110
    zone_height = 110
    offset = 25
    centre_points = [[(0,0) for j in range(num_cols)] for i in range(num_rows)]

    for i in range(0,num_rows):
        for j in range (0,num_cols):
            centre_x = (300 + zone_width*j + zone_width/2  + rand.randrange(-offset,offset))/1000.0
            centre_y = (900 + zone_height*i + zone_height/2 + rand.randrange(-offset,offset))/1000.0
            centre_points[i][j] = (centre_x,centre_y)
    
    print(centre_points)

   
    #delete the objects and then spawn
    for i in range(0,num_rows):
        for j in range (0,num_cols):
            item_name   =   "object_{0}_{1}".format(i,j)
            print("deleting " + item_name)
            delete_model(item_name) #delete model before inserting it

    for i in range(0,num_rows):
        for j in range (0,num_cols):
            orient = Quaternion(*tf.transformations.quaternion_from_euler(0,0,rand.randint(0,360)))
            item_pose = Pose(Point(centre_points[i][j][0],centre_points[i][j][1],0.85 ),   orient)
            item_name   =   "object_{0}_{1}".format(i,j)
            item_type = shape_vector[rand.randint(0,len(shape_vector)-1)]
            print("spawnig " + item_name)
            spawn_model(item_name, item_type, "", item_pose, "world")