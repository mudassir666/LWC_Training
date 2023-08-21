import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContact from '@salesforce/apex/ContactController.createContact';

export default class ModalPopupLWC extends LightningElement {

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
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;

    }

    // Picklist values for isPrimaryContactOptions field
    get isPrimaryContactOptions() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' }
        ];
    }

    // Picklist values for designationOptions field
    get designationOptions() {
        return [
            { label: 'Manager', value: 'Manager' },
            { label: 'Assistant Manager', value: 'Assistant Manager' },
            { label: 'Deputy Manager', value: 'Deputy Manager' },
            { label: 'Executive', value: 'Executive' }
        ];
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

    // to check if the valid fields has been entered or not // method 1
    /*
    isInputValid() {
        let isValidVal = true;
        let inputFields = this.template.querySelectorAll('[data-field="inpt"]'); // to get all input fields

        console.log('Total input fields: ' + inputFields.length);

        inputFields.forEach(inputField => {

            if (inputField.checkValidity()) {
                inputField.showHelpMessageIfInvalid('Kindly fill all the required Fields');
                isValidVal = false;
            }
            else {
                isValidVal = true;
            }

            console.log('input fields name: ' + inputField.name);
            console.log('input fields value: ' + inputField.value);

        });
        console.log('After Loop.....', isValidVal);
        return isValidVal;
    }
*/
    
conFirstName
conLastName
conEmail
conPhone
conDesignation
conDate
conCity
conAddress
conPostalCode
conIsPrimaryContact
conCountry
conAreaOfPractice
   
    // to store values into the contact object
    handleChange(event){
        if(event.target.name == 'conFirstName'){
           this.contact.FirstName = event.target.value;
        }
        else if(event.target.name == 'conLastName'){
            this.contact.LastName = event.target.value;
        }
        else if(event.target.name == 'conEmail'){
            this.contact.Email = event.target.value;
        }
        else if(event.target.name == 'conPhone'){
            this.contact.Phone = event.target.value;
        }
        else if(event.target.name == 'conDesignation'){
            this.contact.Designation__c = event.target.value;
        }
        else if(event.target.name == 'conDate'){
            this.contact.Date = event.target.value;
        }
        else if(event.target.name == 'conCity'){
            this.contact.City = event.target.value;
        }
        else if(event.target.name == 'conAddress'){
            this.contact.Address = event.target.value;
        }
        else if(event.target.name == 'conPostalCode'){
            this.contact.PostalCode = event.target.value;
        }
        else if(event.target.name == 'conIsPrimaryContact'){
            this.contact.Is_Primary_Contact__c = event.target.value;
        }
        else if(event.target.name == 'conCountry'){
            this.contact.Country = event.target.value;
        }
        else if(event.target.name == 'conAreaOfPractice'){
            this.contact.Area_of_Practice__c = event.target.value;
        }
    }
    
    ValidateNameFields(){
        let sendBack = true;

        if (/[^a-zA-Z]/.test(this.contact.FirstName)) {
            this.showToastCall('Error', 'First Name can only contain alphabets', 'error');
            console.log('(ValidateNameFields) First Name can only contain alphabets');
            sendBack = fasle;
        }

        // Check if Last Name field contains anything other than alphabets
        if (/[^a-zA-Z]/.test(this.contact.LastName)) {
            this.showToastCall('Error', 'Last Name can only contain alphabets', 'error');
            console.log('(ValidateNameFields) Last Name can only contain alphabets');
            sendBack = fasle;
        }

        return sendBack;
    }

    handleSubmit() {
        // TO CHECK THE CONTACT OBJECT OUTPUT
        var objMsg = JSON.stringify(this.contact);
        console.log('(handleSubmit) Contact Object = '+objMsg);

        // To check Validity of Input fields
        console.log('(handleSubmit) The outcome of ValidateInput Method = '+this.validateInputs());
        console.log('(handleSubmit) The outcome of ValidateNameFields Method = '+this.ValidateNameFields());
        
        // To check all required fields filled out as well as names must be in proper format
        if (this.validateInputs() && this.ValidateNameFields()) {

            this.showToastCall('Success','All required fields are filled','success','pester');
            // to send contact object from lwc to apex function
            createContact({con : this.contact})
            .then(result =>{
                console.log('(handleSubmit) Contact has been created');
                this.showToastCall('Success',result.LastName+' has been added into the Contact List','success','dismissible');
            })
            .Catch(error =>{
                this.showToastCall('Error','Error msg: '+error,'error','dismissible');
                console.log('Error Toast');
            });

            console.log('Success Toast');

        } else {
            this.showToastCall('Error','Please fill the required fields','error','pester');
            //this.showErrorToast();
            console.log('(handleSubmit) All Required fields are not filled');
            //this.submitDetails();
        }

    }
    
    /*
    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Please fill the required fields',
            variant: 'error',
            mode: 'pester'
        });
        this.dispatchEvent(evt);
    }

    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'All required fields are filled',
            variant: 'success',
            mode: 'pester'
        });
        this.dispatchEvent(evt);
    }
    */
   
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