# this class will hold the project wide constants
$a = window.beats

window.beats.Constants =
  RESTURL: document.location.hostname +  ":" + document.location.port + "/via-rest-api"
  

window.beats.CrudFlag = {
    CREATE: 'CREATE',
    RETRIEVE: 'RETRIEVE',
    UPDATE: 'UPDATE',
    DELETE: 'DELETE'
  }

window.beats.DefaultPosition = {
  Lat: 37.864216,
  Long: -122.279506
}

window.beats.Mode = {
  VIEW: true
  NETWORK: false
  SCENARIO: false
}

window.beats.CCORADB = "ccoradb.path.berkeley.edu"
window.beats.CCTEST = "cctest.path.berkeley.edu"

