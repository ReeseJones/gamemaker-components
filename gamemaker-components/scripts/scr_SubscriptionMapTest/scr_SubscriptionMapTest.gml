tag_script(scr_SubscriptionMapTest, [TAG_UNIT_TEST_SPEC]);
function scr_SubscriptionMapTest() {
	return [
		describe("Subscription Map", function() {
			before_each(function() {
				subscriptionMap = new SubscriptionMap();
			});
			after_each(function() {
				delete subscriptionMap;
			});
			describe("add event subscribers", function () {
			
			});
		})
	];
}