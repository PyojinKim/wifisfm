# WiFi Structure from Motion (SfM)
This package provides a MATLAB implementation of the proposed WiFi Structure from Motion (SfM).

![WiFi Structure from Motion](https://github.com/PyojinKim/wifisfm/blob/master/screenshot.png)


# 1. Goal

Our goal is to construct the indoor WiFi fingerprint database for the indoor GPS system without any manual alignment and calibration by a human.
Existing methods require building's floorplan information priorly, or should perform complicated and tedious indoor preliminary investigation/survey.
To overcome these limitations, we propose the WiFi Structure from Motion (SfM) which constructs the indoor WiFi radio map automatically given the various sensor data from the smartphone obtained by anonymous users (crowdsourcing data) moving inside a building without any prior knowledge or investigation of the indoor structure.

![WiFi Structure from Motion](https://github.com/PyojinKim/wifisfm/blob/master/teaser.png)


# 2. Usage

* Download the dataset from https://www.dropbox.com/s/0y4mljxln4v1ka1/data.zip?dl=0, and extract the zip file.

* The data consists of IMU, WiFi signals, [Google FLP](https://developers.google.com/location-context/fused-location-provider) with the timestamp from the smartphone.

* Initial moving trajectories from RoNIN (or Tango VIO) are not accurate and consistent across multiple data.
  Our code first aligns these multiple trajectories into the global inertial frame by utilizing the location information from the Google FLP.
  We can construct the indoor WiFi radio map with these accurately aligned RoNIN (or Tango VIO) trajectories.

* Run WiFi_SfM_core/main_script_TangoVIO.m (or main_script_RoNIN.m), which will give you the "roughly" aligned VIO trajectories against Google FLP. Enjoy! :)


# 3. Input/Output Format

In the data folder, there are several folders again named as the date of recording sensor data from smartphones.
In folder like 20200316062444R_WiFi_SfM, there are recorded IMU and other sensor measurements in txt files:

* acce.txt: `timestamp, acceleration_x, acceleration_y, acceleration_z \n`
* acce_uncalib.txt: `timestamp, acceleration_x, acceleration_y, acceleration_z \n`
* gyro.txt: `timestamp, gyro_x, gyro_y, gyro_z \n`
* gyro_uncalib.txt: `timestamp, gyro_x, gyro_y, gyro_z \n`
* linacce.txt: `timestamp, user_acceleration_x, user_acceleration_y, user_acceleration_z \n`
* gravity.txt: `timestamp, gravity_x, gravity_y, gravity_z \n`
* magnet.txt: `timestamp, magnetic_x, magnetic_y, magnetic_z \n`
* magnet_uncalib.txt: `timestamp, magnetic_x, magnetic_y, magnetic_z \n`
* rv.txt: `timestamp, quaternion_x, quaternion_y, quaternion_z, quaternion_w \n`
* game_rv.txt: `timestamp, quaternion_x, quaternion_y, quaternion_z, quaternion_w \n`
* magnetic_rv.txt: `timestamp, quaternion_x, quaternion_y, quaternion_z, quaternion_w \n`
* acce_bias.txt: `timestamp, acce_bias_x, acce_bias_y, acce_bias_z \n`
* gyro_bias.txt: `timestamp, gyro_bias_x, gyro_bias_y, gyro_bias_z \n`
* magnet_bias.txt: `timestamp, magnet_bias_x, magnet_bias_y, magnet_bias_z \n`
* wifi.txt: `timestamp, BSSID, RSSI \n`
* step.txt: `timestamp, step_count \n`
* pressure.txt: `timestamp, pressure \n`
* battery.txt: `timestamp, battery_level \n`
* FLP.txt: `timestamp, latitude, longitude, accuracy \n`
* ronin.txt: `timestamp, location_x, location_y \n`
* pose.txt: `timestamp, quaternion_x, quaternion_y, quaternion_z, quaternion_w, location_x, location_y, location_z \n`

As an output file, a time-synchronized location, sensor measurements, and WiFi RSSI vector will be saved.

* datasetRoninIO.mat: `timestamp, location, FLPLocationMeter, magnet, RSSI \n`


# 4. Publications

The WiFi SfM approach is based on the following publications:

* **RoNIN: Robust Neural Inertial Navigation in the Wild: Benchmark, Evaluations, and New Methods** (Sachini Herath, Hang Yan, and Yasutaka Furukawa), ICRA 2020.

You can find more information about RoNIN at https://ronin.cs.sfu.ca/
