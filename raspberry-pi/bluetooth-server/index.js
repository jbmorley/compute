const bleno = require('bleno');

function toggleState() {
    console.log("Toggle State!");
}

bleno.on('stateChange', function(state) {
    console.log('on stateChange: ' + state);
    if (state === 'poweredOn') {
      bleno.startAdvertising('raspberry-pi', ['1803']);
    } else {
      bleno.stopAdvertising();
    }
});

var updater = function() {}

bleno.on('advertisingStart', function(error) {
  if (!error) {
    bleno.setServices([
      // link loss service  
      new bleno.PrimaryService({
        uuid: '1803', 
        characteristics: [
          // Alert Level
          new bleno.Characteristic({
            value: 0, 
            uuid: '2A06',
              properties: ['read', 'write', 'notify'],
              onReadRequest(offset, callback) {
		  console.log("read value");
		  let data = Buffer.alloc(1)
		  data.writeInt8(20)
		  callback(this.RESULT_SUCCESS, data);
              },
              onWriteRequest(data, offset, withoutResponse, callback) {
		  console.log("write value " + data.readInt8());
		  callback(this.RESULT_SUCCESS);
              },
	      onSubscribe(maxValueSize, updateValueCallback) {
		  console.log("subscribe");
		  updater = updateValueCallback;
	      },
          }),
        ],
      }),
      // immediate alert service
      new bleno.PrimaryService({
        uuid: '1802',
        characteristics: [
          // Alert Level
          new bleno.Characteristic({
            value: 0,
            uuid: '2A06',
            properties: ['writeWithoutResponse'],
            onWriteRequest(data, offset, withoutResponse, callback) {
              toggleState();
              callback(this.RESULT_SUCCESS);
            },
          }),
        ],
      }),
    ]);
  }
});

setInterval(function() {
    console.log("tick");
    var data = Buffer.alloc(1)
    data.writeInt8(20)
    updater(data);
}, 1000);
