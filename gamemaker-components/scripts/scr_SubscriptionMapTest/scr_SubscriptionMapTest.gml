TagScript(scr_SubscriptionMapTest, [tag_unit_test_spec]);
function scr_SubscriptionMapTest() {
	return [
		Describe("Subscription Map", function() {
			BeforeEach(function() {
				subscriptionMap = new SubscriptionMap();
			});
			AfterEach(function() {
				delete subscriptionMap;
			});
			Describe("add event subscribers", function () {
			
			});
		})
	];
}