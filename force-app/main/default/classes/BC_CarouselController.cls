public with sharing class BC_CarouselController {
    @AuraEnabled(cacheable=true)
    public static List<String> getImages() {
		List<Product2> publicLinks = [Select Public_image__c from Product2 WHERE IsActive = true AND Public_image__c != ''];
        List<String> urlDoc = new List<String>();
        if(publicLinks.size() > 0) {
            for(Product2 prod: publicLinks) {
                urlDoc.add(prod.Public_image__c);
            }
        }
        return urlDoc;
    }
}
