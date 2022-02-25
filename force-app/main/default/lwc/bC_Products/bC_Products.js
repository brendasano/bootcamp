import { LightningElement, api, wire, track } from 'lwc';
import searchedProds from '@salesforce/apex/BC_ProductController.searchedProds';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import Product2_OBJECT from '@salesforce/schema/Product2';
import Car_Brand__c_FIELD from '@salesforce/schema/Product2.Car_Brand__c';
import Car_model__c_FIELD from '@salesforce/schema/Product2.Car_model__c';
import Vehicle_type__c_FIELD from '@salesforce/schema/Product2.Vehicle_type__c';
import getActiveProduct from '@salesforce/apex/BC_ProductController.getActiveProduct';
import getProductsByQuery from '@salesforce/apex/BC_ProductController.getProductsByQuery';

const columns = [
    // { label: 'Name', fieldName: 'Name', editable: true },
    { label: 'Car Model', fieldName: 'productName',  editable: false},
    { label: 'Car Brand', fieldName: 'productFamily', editable: false },
    { label: 'Image', fieldName: 'linkImage', type: 'image', editable: false },
    { label: 'Color', fieldName: 'color',  editable: false},
    { label: 'Price', fieldName: 'price', type: 'currency', editable: false }
];

export default class BC_Products extends LightningElement {

    @track vehicleValue = '';
    @track brandValue = '';
    @track modelValue = '';
    @track productList = [];
    selectedModel = '';
    selectedVehicle = '';
    selectedBrand = '';
    showNoResultMessage=false;

    @wire(getObjectInfo, { objectApiName: Product2_OBJECT })
    prod2Metadata;
    @wire(getPicklistValues,
        {
            recordTypeId: '$prod2Metadata.data.defaultRecordTypeId', 
            fieldApiName: Vehicle_type__c_FIELD
        }
    ) typePicklist;
    @wire(getPicklistValues,
        {
            recordTypeId: '$prod2Metadata.data.defaultRecordTypeId', 
            fieldApiName: Car_Brand__c_FIELD
        }
    ) brandPicklist;
    @wire(getPicklistValues,
        {
            recordTypeId: '$prod2Metadata.data.defaultRecordTypeId', 
            fieldApiName: Car_model__c_FIELD
        }
    ) modelPicklist;

    columns = columns;
    @track prodsList;
    @wire(searchedProds)
    wiredProds({
        error,
        data
    }){
        if(data){
            console.log('datos::::');
            console.log(data);
            this.prodsList = data;
        } else if(error){
            this.error = error;
            console.log(error);
        }
    }

    handleSelectVehicle(event){
        this.vehicleValue = event.detail.value;
    }
    handleSelectBrand(event){
        this.brandValue = event.detail.value;
    }
    handleSelectModel(event){
        this.modelValue = event.detail.value;
    }

    connectedCallback() {
        this.handleGetActiveProducts();
    }

    handleClick() {
        console.log('this.vehicleValue ====> '+this.vehicleValue);
        console.log('this.modelValue ====> '+this.modelValue);
        console.log('this.brandValue ====> '+this.brandValue);
        if(this.brandValue == "") {
            if(this.vehicleValue == "") {
                this.handleGetActiveProducts();
            } else {
                this.handleGetProducts("",this.modelValue,this.vehicleValue);
            }
        } else {
            this.handleGetProducts(this.brandValue,"","");
        }
    }

    handleGetProducts(brand, model, vehicle) {
        getProductsByQuery({brand : brand, model: model, vehicle: vehicle})
        .then(result => {
            console.log('result.length ====> '+result.length);
            if(result.length > 0) {
                this.productList = result;
                this.showNoResultMessage = false;
                this.showSpinner = false;
            } else {
                this.showNoResultMessage = true;
                this.showSpinner = false;
            }
            
        }).catch(error => {
            console.log('Error : '+JSON.stringify(error));
        })

    }

    handleGetActiveProducts() {
        console.log('Entró a activeProducts');
        getActiveProduct()
        .then(result => {
            console.log('this.columns ======> '+JSON.stringify(this.columns));
            if(result.length > 0) {
                this.productList = result;
                this.showNoResultMessage = false;
                this.showSpinner = false;
            } else {
                this.showNoResultMessage = true;
                this.showSpinner = false;
            }
        }).catch(error => {
            this.error = error;
            console.log('Error : '+JSON.stringify(error));
        })
    }
}