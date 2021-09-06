
-- Chỉ mục tồi
CREATE INDEX vlue_engineCC ON vehicle(VehicleValue, EngineCC);

-- Chỉ mục tốt hơn
CREATE INDEX enginecc_vlue ON vehicle(EngineCC, VehicleValue);