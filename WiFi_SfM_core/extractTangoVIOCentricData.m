function [TangoVIO] = extractTangoVIOCentricData(datasetDirectory, TangoVIOInterval, accuracyThreshold)

% parse pose.txt
TangoVIOFull = parseTangoPoseTextFile([datasetDirectory '/pose.txt']);
TangoVIOFull = TangoVIOFull(1:TangoVIOInterval:end);
numTangoVIOFull = size(TangoVIOFull,2);
TangoVIO = struct('timestamp',cell(1,numTangoVIOFull),'location',cell(1,numTangoVIOFull));
for k = 1:numTangoVIOFull
    TangoVIO(k).timestamp = TangoVIOFull(k).timestamp;
    TangoVIO(k).location = TangoVIOFull(k).stateEsti_Tango(1:2);
end
numTangoVIO = size(TangoVIO,2);


% parse FLP.txt / find the closest Google FLP data
GoogleFLP = parseGoogleFLPTextFile([datasetDirectory '/FLP.txt']);
numGoogleFLP = size(GoogleFLP,2);
TangoVIOTime = [TangoVIO.timestamp];
for k = 1:numGoogleFLP
    
    % current Google FLP data
    timestamp = GoogleFLP(k).timestamp;
    locationDegree = GoogleFLP(k).locationDegree;
    locationMeter = GoogleFLP(k).locationMeter;
    accuracyMeter = GoogleFLP(k).accuracyMeter;
    
    
    % save Google FLP data in Tango VIO
    [timeDifference, indexTangoVIO] = min(abs(timestamp - TangoVIOTime));
    if ((timeDifference < 0.5) && (accuracyMeter < accuracyThreshold))
        TangoVIO(indexTangoVIO).FLPLocationDegree = locationDegree;
        TangoVIO(indexTangoVIO).FLPLocationMeter = locationMeter;
        TangoVIO(indexTangoVIO).FLPAccuracyMeter = accuracyMeter;
    end
end


% parse magnet.txt file / find the closest magnetic field data
magnet = parseMagnetTextFile([datasetDirectory '/magnet.txt']);
magnetTime = [magnet.timestamp];
for k = 1:numTangoVIO
    [timeDifference, indexMagnet] = min(abs(TangoVIO(k).timestamp - magnetTime));
    if (timeDifference < 0.5)
        TangoVIO(k).magnet = magnet(indexMagnet).magnet;
    end
end


% parse game_rv.txt file / find the closest game rotation vector (R_gb)
gameRV = parseGameRVTextFile([datasetDirectory '/game_rv.txt']);
gameRVTime = [gameRV.timestamp];
for k = 1:numTangoVIO
    [timeDifference, indexGameRV] = min(abs(TangoVIO(k).timestamp - gameRVTime));
    if (timeDifference < 0.5)
        TangoVIO(k).R_gb = gameRV(indexGameRV).R_gb;
    end
end


end
