describe("LinkListCollection", function() {
  $a = window.sirius;
  var models, network, begin, end;
  
  beforeEach(function() {
    network = $a.scenario.get('networklist').get('network')[0];
    models = network.get('linklist').get('link');
    spyOn($a.LinkListCollection.prototype, 'addLink').andCallThrough();
    spyOn($a.LinkListCollection.prototype, 'removeLink').andCallThrough();
    this.lColl= new $a.LinkListCollection(models);
    begin = models[0].get('begin');
    end = models[0].get('end');
  });
  
  describe("Instantiation", function() {
    it("sets models to a collection of links", function() {
      expect(this.lColl.models).not.toBeNull();
    });
    
    it("should be watching addLink", function() {
      $a.broker.trigger("link_coll:add", {begin:begin,end:end});
      expect($a.LinkListCollection.prototype.addLink).toHaveBeenCalled();
    });

    it("should be watching removeLink", function() {
      this.lColl.trigger("links:remove", models[0].cid);
      expect($a.LinkListCollection.prototype.removeLink).toHaveBeenCalled();
    });
  });
  
   describe("getBrowserColumnData", function() {
      var desc = "should return id, name,road_name, type, lanes, ";
      desc += "begin node name, and end node name for editor browser table";
       it(desc, function() {
       arrColumnsData = this.lColl.getBrowserColumnData();
       lColl = this.lColl.models[0];
       expect(arrColumnsData[0][0]).toEqual(lColl.get('id'));
       expect(arrColumnsData[0][1]).toEqual(lColl.get('name'));
       expect(arrColumnsData[0][2]).toEqual(lColl.get('road_name'));
       expect(arrColumnsData[0][3]).toEqual(lColl.get('type'));
       expect(arrColumnsData[0][4]).toEqual(lColl.get('lanes'));
       nodeB = lColl.get('begin').get('node');
       nodeE = lColl.get('end').get('node');
       expect(arrColumnsData[0][5]).toEqual(nodeB.get('name'));
       expect(arrColumnsData[0][6]).toEqual(nodeE.get('name'));
     });
   });
  
  describe("removeLink ", function() {
    it("should remove a link from the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.removeLink(models[0].cid);
      expect(lengthBefore - 1).toEqual(this.lColl.length);
    });
  });
  
  describe("addLink ", function() {
    it("should create a new link and add it to the collection", function() {
      var lengthBefore = this.lColl.length;
      this.lColl.addLink({begin:begin,end:end});
      expect(lengthBefore + 1).toEqual(this.lColl.length);
    });
  });
  
  describe("removeNode ", function() {
    it("should remove the begin or end node from link", function() {
      this.lColl.removeNode(this.lColl.models[0],'End');
      expect(this.lColl.models[0].get('End')).toBeNull();
    });
  });
});