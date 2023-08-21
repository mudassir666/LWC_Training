import { LightningElement, track, wire } from 'lwc';
import getSObjectsFromSchema from '@salesforce/apex/AssignmentRuleController.getSObjectsFromSchema';
import getSObjectFields from '@salesforce/apex/AssignmentRuleController.getSObjectFields';

export default class AssignmentRule extends LightningElement {

    // 1) To call the connectedCallback for getting and setting data from Apex
   connectedCallback(){
    this.init();  
 }

   // 3) Use to store Accounts got from Init method 
    @track sObjects = [];
    @track fields = [];
    isPickList= false;
    @track pickListValuesOption=[];
   // @track sObjects2 = ['contact','account'];

 // 2) To call in connectedCallback for getting and setting data from Apex 
 init(){
    
    console.log('(Init) Start');
    getSObjectsFromSchema({}).then(success=>{
       // success.accList[0].selected = true; // use to select the first record of the list by making it true
 ////////////////////////////////////////////////      
       // Sorting the object and storing it into sObjects
       this.sObjects = success.sort((a, b) => a.label.localeCompare(b.label));

      /* for(let object of this.sObjects){
       console.log(object.label);
       }
      */
       this.sObjects.forEach((object)=> console.log(object.label));
        //this.sObjects=success;
/////////////////////////////////////////////////////

        //this.stateCodes=success.stateCodes.map((record)=>({label: record, value: record}));
        //pagination
        this.totalRecords = success.length; // update total records count                 
        // this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
        //this.pageSize = 10;
       // this.paginationHelper(); // call helper menthod to update pagination logic 
       // this.selectFirstAccount();
        //pagination

        console.log('(Init) sObjects count > '+ this.sObjects.length);
        console.log('(Init) Apex sObjects list = ', this.sObjects);
        console.log('(Init) sObjects '+ JSON.stringify(this.sObjects))

      }).catch(error=>{
        console.log("(Init) Error = "+JSON.stringify(error));
      })
      
      // just to clear the place holder values into picklists
     /*
      this.Ownership = null;
      this.Industry = null;
      this.NoOfEmployees = null;
      this.State = null;
      */
   }

   handleChange(event){
        if (event.target.name== 'conSelectObject') {
            console.log('object selection;;;;;;;;;;; ',event.target.value);
            this.getFields(event.target.value);
        }
        else if (event.target.name== 'conField') {
            let selectedOption = this.fields.find(option => option.value === event.target.value);
            console.log('selectedOption.dataType :::::::::::::',selectedOption.dataType);

            if (selectedOption.dataType=='PICKLIST') {
                console.log('selectedOption.pickListValues::::::::::::::::: ',JSON.stringify(selectedOption.pickListValues));
                this.isPickList=true;
                this.pickListValuesOption = selectedOption.pickListValues;

            }
            else{
                this.isPickList=false;
                this.pickListValuesOption = [];

            }
            //this.selectedOption = event.detail.value;
            console.log('field selection;;;;;;;;;;; ',event.target.value);
            //this.getFields(event.target.value);
            // console.log('field type;;;;;;;;;;; ',event.detail.value);
        }

   }
   
   getFields(objectName){
    getSObjectFields({sObjectName : objectName}).then(success=>{     
        // Sorting the object and storing it into sObjects
        this.fields = success.sort((a, b) => a.label.localeCompare(b.label));
        // this.fields = [    
        //     { label: 'Option 1', value: 'option1', extraProp: 'extraValue1' },
        //     { label: 'Option 2', value: 'option2', extraProp: 'extraValue2' },
        //     { label: 'Option 3', value: 'option3', extraProp: 'extraValue3' }];
    
       
       // this.sObjects.forEach((object)=> console.log(object.label));
                       
        
    
         console.log('(getFields) fields count > '+ this.fields.length);
         console.log('(getFields) Apex fields list = ', this.fields);
         console.log('(getFields) fields '+ JSON.stringify(this.fields))
    
       }).catch(error=>{
         console.log("(getFields) Error = "+JSON.stringify(error));
       })
   }
 
}