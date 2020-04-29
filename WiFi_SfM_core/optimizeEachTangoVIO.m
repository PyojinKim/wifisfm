function [TangoVIO] = optimizeEachTangoVIO(TangoVIO)
%% (1) measurements (constants)

% Tango VIO constraints (relative movement)
TangoPolarVIO = convertTangoVIOPolarCoordinate(TangoVIO);
numTangoVIO = size(TangoPolarVIO,2);


% Google FLP constraints (global location)
TangoGoogleFLPIndex = [];
for k = 1:numTangoVIO
    if (~isempty(TangoVIO(k).FLPLocationMeter))
        TangoGoogleFLPIndex = [TangoGoogleFLPIndex, k];
    end
end
TangoGoogleFLPLocation = [TangoVIO.FLPLocationMeter];


% Google FLP offset for 2D rigid body rotation
offset = TangoGoogleFLPLocation(:,1);
TangoGoogleFLPLocation = TangoGoogleFLPLocation - offset;


% sensor measurements from Tango VIO, Google FLP
sensorMeasurements.TangoPolarVIODistance = [TangoPolarVIO.distance];
sensorMeasurements.TangoPolarVIOAngle = [TangoPolarVIO.angle];
sensorMeasurements.TangoGoogleFLPIndex = TangoGoogleFLPIndex;
sensorMeasurements.TangoGoogleFLPLocation = TangoGoogleFLPLocation;
sensorMeasurements.TangoGoogleFLPAccuracy = [TangoVIO.FLPAccuracyMeter];


%% (2) model parameters (variables) for Tango VIO drift correction model

% initialize Tango VIO drift correction model parameters
modelParameters.startLocation = TangoGoogleFLPLocation(:,1).';
modelParameters.rotation = 0;
X_initial = [modelParameters.startLocation, modelParameters.rotation];


%% (3) nonlinear optimization

% run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed','MaxIterations',400);
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual_Tango_GoogleFLP(sensorMeasurements, x),X_initial,[],[],options);


% optimal model parameters for Tango VIO drift correction model
TangoPolarVIODistance = sensorMeasurements.TangoPolarVIODistance;
TangoPolarVIOAngle = sensorMeasurements.TangoPolarVIOAngle;
X_optimized = vec;
startLocation = X_optimized(1:2).';
rotation = X_optimized(3);
scale = ones(1,numTangoVIO);
bias = zeros(1,numTangoVIO);
TangoVIOLocation = DriftCorrectedTangoVIOAbsoluteAngleModel(startLocation, rotation, scale, bias, TangoPolarVIODistance, TangoPolarVIOAngle);


% Google FLP offset for 2D rigid body rotation
TangoVIOLocation = TangoVIOLocation + offset;


% save drift-corrected Tango VIO location
for k = 1:numTangoVIO
    TangoVIO(k).location = TangoVIOLocation(:,k);
end


end

