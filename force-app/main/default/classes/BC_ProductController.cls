public with sharing class BC_ProductController {
    @AuraEnabled
    public static List<productWrapper> getActiveProduct() {
        List<PriceBookEntry> lstpbe = [SELECT Product2.Id, Product2.Name, Product2.Car_model__c, Product2.Public_image__c,
                                        Product2.Car_color__c, Product2.Car_brand__c, Product2.ProductCode, Product2.IsActive, UnitPrice, Product2.Vehicle_type__c
                                        FROM PriceBookEntry 
                                        WHERE Product2Id IN (SELECT Id 
                                                FROM Product2
                                                Product2 WHERE Public_image__c != '')];
        List<productWrapper> pdw = new List<productWrapper>();
        for(PriceBookEntry pbEntry : lstpbe) {
            productWrapper newProd = new productWrapper();
            newProd.Id = pbEntry.Product2.Id;
            newProd.productName = pbEntry.Product2.Car_model__c;
            newProd.productFamily = pbEntry.Product2.Car_brand__c;
            newProd.linkImage = pbEntry.Product2.Public_image__c;
            newProd.color = pbEntry.Product2.Car_color__c;
            newProd.price = String.valueOf(pbEntry.UnitPrice);
            newProd.isActive = pbEntry.Product2.IsActive;
            pdw.add(newProd);
        }
        return pdw;
    }
    @AuraEnabled(cacheable=true)
    public static List<productWrapper> searchedProds(){
        List<PriceBookEntry> lstpbe = [SELECT Product2.Id, Product2.Name, Product2.Car_model__c, Product2.Public_image__c,
                                       	Product2.Car_color__c, Product2.ProductCode, Product2.IsActive, UnitPrice, Product2.Vehicle_type__c
                               		   	FROM PriceBookEntry 
                               			WHERE Product2Id IN (SELECT Id 
                                                      FROM Product2
                                                      Product2 WHERE Public_image__c != '')];
        List<productWrapper> pdw = new List<productWrapper>();
        for(PriceBookEntry pbEntry : lstpbe) {
            productWrapper newProd = new productWrapper();
            newProd.Id = pbEntry.Product2.Id;
            newProd.productName = pbEntry.Product2.Car_model__c;
            newProd.productCode = pbEntry.Product2.ProductCode;
            newProd.productFamily = pbEntry.Product2.Family;
            newProd.linkImage = pbEntry.Product2.Public_image__c;
            newProd.color = pbEntry.Product2.Car_color__c;
            newProd.price = String.valueOf(pbEntry.UnitPrice);
            newProd.isActive = pbEntry.Product2.IsActive;
            pdw.add(newProd);
        }
        return pdw;
    }

    @AuraEnabled
    public static List<productWrapper> getProductsByQuery(String brand, String model, String vehicle) {
        Set<Id> productIds = new Set<Id>();
        List<Product2> records = new List<Product2>();
        String link = '';
	
        String query = 'SELECT Id from Product2 WHERE Public_image__c !=:link';
        if (!string.isEmpty(brand))        
        {
            query+=' and Car_Brand__c=:brand';
        } else {
            if (!string.isEmpty(model))        
            {
                query+=' and Car_model__c=:model';  
            }
            if (!String.isEmpty(vehicle))        
            {
                query+=' and Vehicle_type__c=:vehicle';
            }
        }
     	records = Database.query(query);
        System.debug('Records =======> '+records);
        for(Product2 prod : records) {
            productIds.add(prod.Id);
        }
        List<PriceBookEntry> lstpbe = [SELECT Product2.Id, Product2.Name, Product2.Car_Brand__c, Product2.Car_model__c, Product2.Public_image__c,
                                       	Product2.Car_color__c, Product2.ProductCode, Product2.IsActive, UnitPrice, Product2.Vehicle_type__c
                               		   	FROM PriceBookEntry 
                               			WHERE Product2Id IN :productIds];
        List<productWrapper> pdw = new List<productWrapper>();
        for(PriceBookEntry pbEntry : lstpbe) {
            productWrapper newProd = new productWrapper();
            newProd.Id = pbEntry.Product2.Id;
            newProd.productName = pbEntry.Product2.Car_model__c;
            newProd.productCode = pbEntry.Product2.ProductCode;
            newProd.productFamily = pbEntry.Product2.Car_model__c;
            newProd.linkImage = pbEntry.Product2.Public_image__c;
            newProd.color = pbEntry.Product2.Car_color__c;
            newProd.price = String.valueOf(pbEntry.UnitPrice);
            newProd.isActive = pbEntry.Product2.IsActive;
            pdw.add(newProd);
        }
        System.debug('productWrapper =========> '+pdw);
        return pdw;
    }

    public class productWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String productName;
        @AuraEnabled public String productCode;
        @AuraEnabled public String vehicle;
        @AuraEnabled public String productFamily;
        @AuraEnabled public String linkImage;
        @AuraEnabled public String color;
        @AuraEnabled public String price;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public String description;
    }
}
