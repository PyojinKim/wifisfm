# WiFi Structure from Motion (SfM)
This package provides a MATLAB implementation of the proposed WiFi Structure from Motion (SfM).

![WiFi Structure from Motion](https://github.com/PyojinKim/wifisfm/blob/master/screenshot.png)


# 1. Goal

Our goal is to construct the indoor WiFi fingerprint database for the indoor GPS system without any manual alignment and calibration by a human.
Existing methods require building's floorplan information priorly, or should perform complicated and tedious indoor preliminary investigation/survey.
To overcome these limitations, we propose the WiFi Structure from Motion (SfM) which constructs the indoor WiFi radio map automatically given the various sensor data from the smartphone obtained by anonymous users (crowdsourcing data) moving inside a building without any prior knowledge or investigation of the indoor structure.

![WiFi Structure from Motion](https://github.com/PyojinKim/wifisfm/blob/master/teaser.png)


# 2. Usage

* Download the dataset from https://www.dropbox.com/s/qfnu7s655r72emy/data.zip?dl=0, and extract the zip file.

* The data consists of IMU, WiFi signals, [Google FLP](https://developers.google.com/location-context/fused-location-provider) with the timestamp from the smartphone.

* Initial moving trajectories from RoNIN (or Tango VIO) are not accurate and consistent across multiple data.
  Our code first aligns these multiple trajectories into the global inertial frame by utilizing the location information from the Google FLP.
  We can construct the indoor WiFi radio map with these accurately aligned RoNIN (or Tango VIO) trajectories.

* Run WiFi_SfM_core/main_script_TangoVIO.m (or main_script_RoNIN.m), which will give you the "roughly" aligned VIO trajectories against Google FLP. Enjoy! :)


# 3. Publications

The WiFi SfM approach is based on the following publications:

* **RoNIN: Robust Neural Inertial Navigation in the Wild: Benchmark, Evaluations, and New Methods** (Sachini Herath, Hang Yan, and Yasutaka Furukawa), ICRA 2020.

You can find more information about RoNIN at https://ronin.cs.sfu.ca/
