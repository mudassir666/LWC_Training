public with sharing class AssignmentRuleController {
    
    // Ref : https://sfdctree.wordpress.com/2020/07/22/how-to-get-the-list-of-all-sobjects-in-salesforce/#:~:text=How%20to%20get%20the%20list%20of%20all%20SObjects,getName%20%28%29%20Returns%20the%20name%20of%20the%20object.
    @AuraEnabled
    public static List<Map<String,String>> getSObjectsFromSchema(){
        
        // to store list of maps => sObjectsList ({label=Contract, value=Contract}, {label=Order, value=Order})
        List <Map<String,String>> sObjectsList = new List <Map<String,String>>();
        
 
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            
            // storing the sobject name and label into the strings
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            
            // applying a few conditions
            if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
               !name.containsignorecase('share') && !name.containsignorecase('feed') && 
               !name.containsignorecase('group') && !name.containsignorecase('public') &&
               !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() 
               && objTyp.getDescribe().getRecordTypeInfos().size() > 0
              ){      
                   // adding the label and name into the map and then add into list
                   sObjectsList.add(new Map<String,String>{'label'=>label, 'value'=>name});
               }
        }
        
        
        System.debug(sObjectsList.size());
        System.debug('sObjectsList '+sObjectsList);
        return sObjectsList;
        
    }
    
    
    // This Method is use to get the fields of a given object
    // Ref : https://www.sfdcstop.com/2021/08/understanding-dynamic-apex-and-its-use.html
    @AuraEnabled
    public static List<Map<String,Object>> getSObjectFields(String sObjectName){
        
        // This List is use to store the field names, data-types and Picklist values
        List<Map<String,Object>> fieldsList = new List <Map<String,Object>>();
        
        // * Getting the reference to current sObject
        Schema.SObjectType sObjectTypeInstance = Schema.getGlobalDescribe().get(sObjectName);
        system.debug('1 (Schema.SObjectType) sObjectTypeInstance ='+sObjectTypeInstance);

     if(sObjectTypeInstance != null){
    
    // * Getting Fields for current sObject
    Map<String,Schema.SObjectField> fieldMap = sObjectTypeInstance.getDescribe().fields.getMap();
    system.debug('2 (Schema.SObjectField) fieldMap ='+fieldMap);
    
    // * Checking each field one by one if its accessible adding its name to fieldNames set
    for(Schema.sObjectField field : fieldMap.values()){
        
        Schema.DescribeFieldResult fieldResult = field.getDescribe();
        
        if(fieldResult.isAccessible()){
          
            if( String.valueOf(fieldResult.getType()) == 'PickList'){
                List<Map<String,String>> getPicklistValues =  getPicklistValues(fieldResult);
                fieldsList.add(new Map<String,Object>{'label'=>fieldResult.getLabel(), 'value'=>fieldResult.getName(), 'dataType'=> String.valueOf(fieldResult.getType()), 'pickListValues'=> getPicklistValues});
            }
            else{
            	fieldsList.add(new Map<String,Object>{'label'=>fieldResult.getLabel(), 'value'=>fieldResult.getName(), 'dataType'=> String.valueOf(fieldResult.getType())});    
            }
            
            //fieldsList.add(new Map<String,Object>{'label'=>fieldResult.getLabel(), 'value'=>fieldResult.getName(), 'dataType'=> fieldResult.getType(), 'pickListValues'=>fieldResult.getPicklistValues().getValue()});
        }
    }
}
        system.debug('(Size) : '+fieldsList.size());
        return fieldsList;
    }
    

// This method is use to get the values from a picklist into this format = ({label=Contract, value=Contract}, {label=Order, value=Order})
public static List<Map<String,String>> getPicklistValues(Schema.DescribeFieldResult picklist){
    
        List<Map<String,String>> listPicklistValues = new List<Map<String,String>>();
    
       // Map<String, String> picklistFieldMap = new Map<String, String>();
        // * Getting all picklist entries
        List<Schema.PicklistEntry> picklistEntries = picklist.getPicklistValues();

        // * Looping over all picklist entries one by one
        for(Schema.PicklistEntry picklistEntry : picklistEntries) {

            // * If the picklist entry is active, getting the label and value and putting those in list of maps
            if(picklistEntry.isActive()) {
                String picklistLabel = picklistEntry.getLabel();
                String picklistValue = picklistEntry.getValue();
                //picklistFieldMap.put(picklistValue, picklistLabel);
               // picklistFieldMap.put('label', picklistLabel);
                //picklistFieldMap.put('value', picklistValue);
                listPicklistValues.add(new Map<String,String>{'label'=> picklistLabel,'value'=> picklistValue});
            }
        }
    
    
    return listPicklistValues;
}

    
}