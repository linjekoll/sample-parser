# -*- encoding : utf-8 -*-
Stations = JSON.parse(
  <<-long
    [
    {
        "name": "Mölndal centrum",
        "id": "00012110",
        "time_from_prev_station": null,
        "destination_station": 21,
        "origin_station": null,
        "station_id": 1
    },
    {
        "name": "Mölndals sjukhus",
        "id": "00012130",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 1,
        "station_id": 2
    },
    {
        "name": "Lackarebäck",
        "id": "00012140",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 2,
        "station_id": 3
    },
    {
        "name": "Krokslätts Fabriker",
        "id": "00012141",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 3,
        "station_id": 4
    },
    {
        "name": "Krokslätts torg",
        "id": "00012270",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 4,
        "station_id": 5
    },
    {
        "name": "Lana",
        "id": "00004310",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 5,
        "station_id": 6
    },
    {
        "name": "Varbergsgatan",
        "id": "00007270",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 6,
        "station_id": 7
    },
    {
        "name": "Elisedal",
        "id": "00002210",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 7,
        "station_id": 8
    },
    {
        "name": "Almedal",
        "id": "00001050",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 8,
        "station_id": 9
    },
    {
        "name": "Getebergsäng",
        "id": "00002700",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 9,
        "station_id": 10
    },
    {
        "name": "Korsvägen",
        "id": "00003980",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 10,
        "station_id": 11
    },
    {
        "name": "Berzeliigatan",
        "id": "00001420",
        "time_from_prev_station": 60,
        "destination_station": 21,
        "origin_station": 11,
        "station_id": 12
    },
    {
        "name": "Valand",
        "id": "00007220",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 12,
        "station_id": 13
    },
    {
        "name": "Kungsportsplatsen",
        "id": "00004090",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 13,
        "station_id": 14
    },
    {
        "name": "Brunnsparken",
        "id": "00001760",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 14,
        "station_id": 15
    },
    {
        "name": "Centralstationen",
        "id": "00001950",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 15,
        "station_id": 16
    },
    {
        "name": "Gamlestadstorget",
        "id": "00002670",
        "time_from_prev_station": 360,
        "destination_station": 21,
        "origin_station": 16,
        "station_id": 17
    },
    {
        "name": "Hjällbo",
        "id": "00003200",
        "time_from_prev_station": 360,
        "destination_station": 21,
        "origin_station": 17,
        "station_id": 18
    },
    {
        "name": "Hammarkullen",
        "id": "00003080",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 18,
        "station_id": 19
    },
    {
        "name": "Storås",
        "id": "00006360",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 19,
        "station_id": 20
    },
    {
        "name": "Angered Centrum",
        "id": "00001075",
        "time_from_prev_station": 120,
        "destination_station": 21,
        "origin_station": 20,
        "station_id": 21
    }
  ]
  long
)

provider_id = 1
line_id     = 1
alert_messages = ["Tram is on fire"]