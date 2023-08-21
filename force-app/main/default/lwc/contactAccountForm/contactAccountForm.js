import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContact from '@salesforce/apex/ContactController.createContactAccount';

export default class ContactAccountForm extends LightningElement {
    
    @api accid = null;

    // getting contact object
    @track contact = {};

    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.contact.FirstName = null;
        this.contact.LastName = null;

    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;

    }
    

    handleChange(event){
        if(event.target.name == 'conFirstName'){
            this.contact.FirstName = event.target.value;
         }
         else if(event.target.name == 'conLastName'){
             this.contact.LastName = event.target.value;
         }
    }

    checkAccId(){
        let sendback = false;
        if(this.accid != null){
            this.contact.AccountId = this.accid;
            console.log('Not null ',this.contact.AccountId);
            sendback = true;
        }
        return sendback;

    }

     // to check if the valid fields has been entered or not // method 2
     validateInputs(){

        const isValidVal = [

             ...this.template.querySelectorAll('[data-field="inpt"]'),

         ].reduce((validSoFar, inputCmp) => {

             inputCmp.reportValidity();

             return validSoFar && inputCmp.checkValidity();

         }, true);

         return isValidVal
         }

    handleSubmit(){
        // TO CHECK THE CONTACT OBJECT OUTPUT
        var objMsg = JSON.stringify(this.contact);
        console.log('(handleSubmit) Contact Object = '+objMsg);
        console.log('Size of Object'+Object.keys(this.contact).length);
        console.log('Accound ID = '+this.accid);
        console.log('Contact Accound ID = '+this.contact.AccountId);
        this.checkAccId();
        if(this.validateInputs() && this.checkAccId() == true){
            // to send contact object from lwc to apex function
            createContact({con : this.contact})
            .then(result =>{
                console.log('(handleSubmit) Contact has been created '+result);
                this.showToastCall('Success',this.contact.LastName+' has been added into the Contact List','success','dismissible');
                this.closeModal();
            })
            .Catch(error =>{
               this.showToastCall('Error','Error msg: '+error,'error','dismissible');
                //console.log('Error Toast '+error);
            });
        }
        else{
            console.log('Empty');
            this.showToastCall('Error','Fields are Empty','error','dismissible');
        }
    }

    // Toast Method for Success and Error Messages
    showToastCall(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }




}