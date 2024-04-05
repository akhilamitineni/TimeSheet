import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSkillResources from '@salesforce/apex/SkillResourceController.getSkillResources';
import { refreshApex } from '@salesforce/apex';
import updateSkillResourceRecords from '@salesforce/apex/SkillResourceController.updateSkillResourceRecords';
export default class DynamicRow3 extends LightningElement {

    @track skillResources = [];
    modifiedDBRecordsId = [];
    @api recordId;
    error;
    wiredSkillResourceResult;
    idToDelete = [];
    preventSavingRecord = false;

    @wire(getSkillResources, { resourceId: '$recordId' })
    wiredSkillResourceRec(result) {
        this.wiredSkillResourceResult = result;
        if (result.data) {
            this.handleData(result.data)
        } else if (result.error) {
            this.error = result.error;
        }
    }

    connectedCallback() {
        console.log('Inside Connected Call Back');
    }

    handleData(data) {
        if (data != undefined) {
            if (data.length <= 0) {
                this.createRow(this.skillResources);
            } else if (data.length > 0) {
                let items = [];
                for (let i = 0; i < data.length; i++) {
                    let skillResource = {};
                    skillResource.index = i + 1;
                    skillResource.Id = data[i].Id;
                    skillResource.dbt__Resource__c = data[i].dbt__Resource__c;
                    skillResource.dbt__Skill__c = data[i].dbt__Skill__c;
                    skillResource.dbt__Start_date__c = data[i].dbt__Start_date__c;
                    skillResource.dbt__End_date__c = data[i].dbt__End_date__c;
                    skillResource.dbt__Version_Release__c = data[i].dbt__Version_Release__c;
                    skillResource.dbt__Experience__c = data[i].dbt__Experience__c;
                    skillResource.dbt__Experience_Formula__c = data[i].dbt__Experience_Formula__c;
                    skillResource.dbt__Level_of_Experience__c = data[i].dbt__Level_of_Experience__c;
                    skillResource.startDateValidation = false;
                    skillResource.skillValidation = false;
                    skillResource.endDateValidation = false;
                    skillResource.experienceValidation = false;
                    skillResource.levelOfExperienceValidation = false;
                    if (data[i].dbt__Experience__c !== null && data[i].dbt__Experience__c !== '' && data[i].dbt__Experience__c !== undefined) {
                        skillResource.startdateVisibility = true;
                        skillResource.enddateVisibility = true;
                    } else {
                        skillResource.startdateVisibility = false;
                        skillResource.enddateVisibility = false;
                    }

                    if (data[i].dbt__Start_date__c != null || data[i].dbt__End_date__c != null) {
                        skillResource.isFormula = 'slds-show';
                        skillResource.isText = 'slds-hide';
                    } else {
                        skillResource.isFormula = 'slds-hide';
                        skillResource.isText = 'slds-show';
                    }
                    items.push(skillResource);
                }
                this.skillResources = items;
                this.error = undefined;
            }
        }
    }

    createRow(skillResources) {
        let skillResource = {};
        if (skillResources.length > 0) {
            skillResource.index = skillResources[skillResources.length - 1].index + 1;
        } else {
            skillResource.index = 1;
        }
        skillResource.dbt__Resource__c = this.recordId;
        skillResource.dbt__Skill__c = null;
        skillResource.dbt__Start_date__c = null;
        skillResource.dbt__End_date__c = null;
        skillResource.dbt__Version_Release__c = null;
        skillResource.dbt__Experience__c = null;
        skillResource.dbt__Level_of_Experience__c = null;
        skillResource.isFormula = 'slds-hide';
        skillResource.isText = 'slds-show';
        skillResource.startDateValidation = false;
        skillResource.skillValidation = false;
        skillResource.endDateValidation = false;
        skillResource.experienceValidation = false;
        skillResource.levelOfExperienceValidation = false;
        skillResource.startdateVisibility = false;
        skillResource.enddateVisibility = false;
        skillResources.push(skillResource);
    }

    addNewRow() {
        this.createRow(this.skillResources);
    }

    removeRow(event) {
        let toBeDeletedRowIndex = event.target.dataset.id;
        let Id = event.target.dataset.recordId;
        let skillResources = [];
        for (let i = 0; i < this.skillResources.length; i++) {
            let tempRecord = Object.assign({}, this.skillResources[i]); //cloning object
            if (tempRecord.index != toBeDeletedRowIndex) {
                skillResources.push(tempRecord);
            } else {
                this.idToDelete.push(tempRecord.Id);
            }
        }
        for (let i = 0; i < skillResources.length; i++) {
            skillResources[i].index = i + 1;
        }
        this.skillResources = skillResources;
    }

    handleChange(event) {
        let index = event.target.dataset.id;
        let field = event.target.name;
        let value = event.target.value;
        let Id = event.target.dataset.recordId;

        for (let i = 0; i < this.skillResources.length; i++) {
            if (this.skillResources[i].index === parseInt(index)) {
                this.skillResources[i][field] = value;
            }
        }

        for (let i = 0; i < this.skillResources.length; i++) {
            if (this.skillResources[i].index === parseInt(index)) {

                if ((this.skillResources[i].dbt__Start_date__c !== null && this.skillResources[i].dbt__Start_date__c !== '' && this.skillResources[i].dbt__Start_date__c !== undefined)
                    ||
                    (this.skillResources[i].dbt__End_date__c !== null && this.skillResources[i].dbt__End_date__c !== '' && this.skillResources[i].dbt__End_date__c !== undefined)) {
                    this.skillResources[i].isFormula = 'slds-show';
                    this.skillResources[i].isText = 'slds-hide';
                    this.skillResources[i].dbt__Experience__c = null;
                } else {
                    this.skillResources[i].isFormula = 'slds-hide';
                    this.skillResources[i].isText = 'slds-show';
                }

                if (this.skillResources[i].dbt__Experience__c !== null && this.skillResources[i].dbt__Experience__c !== '' && this.skillResources[i].dbt__Experience__c !== undefined) {
                    this.skillResources[i].startdateVisibility = true;
                    this.skillResources[i].enddateVisibility = true;
                    this.skillResources[i].dbt__Start_date__c = null;
                    this.skillResources[i].dbt__End_date__c = null;
                    this.skillResources[i].experienceValidation = false;
                    this.skillResources[i].experienceMessage = '';
                } else {
                    this.skillResources[i].startdateVisibility = false;
                    this.skillResources[i].enddateVisibility = false;
                }
                if (this.skillResources[i].dbt__Start_date__c == null || this.skillResources[i].dbt__Start_date__c == '' || this.skillResources[i].dbt__Start_date__c == undefined) {
                    this.skillResources[i].startDateValidation = false;
                    this.skillResources[i].startDateMessage = '';
                } else {
                    this.skillResources[i].experienceValidation = false;
                    this.skillResources[i].experienceMessage = '';
                }

                if (this.skillResources[i].dbt__End_date__c == null || this.skillResources[i].dbt__End_date__c == '' || this.skillResources[i].dbt__End_date__c == undefined) {
                    this.skillResources[i].endDateValidation = false;
                    this.skillResources[i].endDateMessage = '';
                }

                if (this.skillResources[i].dbt__Skill__c != null) {
                    this.skillResources[i].skillValidation = false;
                    this.skillResources[i].skillMessage = '';
                }

                if (this.skillResources[i].dbt__Level_of_Experience__c != null) {
                    this.skillResources[i].levelOfExperienceValidation = false;
                    this.skillResources[i].levelofExperianceMessage = '';
                }
            }
        }


        if (Id != '' && this.idToDelete.includes(Id) == false) {
            if (this.modifiedDBRecordsId.includes(Id) == false) {
                this.modifiedDBRecordsId.push(Id);
            }
        }
    }


    handleCancel() {
        location.reload();
    }

    createSkillResources() {

        let updateArray = [];
        let finalRecords = [];
        if (this.modifiedDBRecordsId.length != 0) {
            for (let i = 0; i < this.skillResources.length; i++) {
                if (this.modifiedDBRecordsId.includes(this.skillResources[i].Id) && this.skillResources[i].Id !== undefined) {
                    updateArray.push(this.skillResources[i]);
                }
            }
        }
        let newRecArray = [];
        for (let i = 0; i < this.skillResources.length; i++) {
            if (this.skillResources[i].Id == undefined) {
                newRecArray.push(this.skillResources[i]);
            }
        }
        let combinedArray = newRecArray.concat(updateArray);
        const currentMonth = new Date().getMonth() + 1;
        const currentYear = new Date().getFullYear();
        const regex = new RegExp('^([0-9]{2})\/[2][0][0-9]{2}$');
        for (let i = 0; i < combinedArray.length; i++) {
            let tempRecords = combinedArray[i];

            //skill  Validation
            if (tempRecords.dbt__Skill__c == null || tempRecords.dbt__Skill__c == '' || tempRecords.dbt__Skill__c == undefined) {
                tempRecords.skillValidation = true;
                tempRecords.skillMessage = 'Please fill Skill';
            } else {
                tempRecords.skillValidation = false;
                tempRecords.skillMessage = '';
            }

            //Level of experience Validation
            if (tempRecords.dbt__Level_of_Experience__c == null || tempRecords.dbt__Level_of_Experience__c == '' || tempRecords.dbt__Level_of_Experience__c == undefined) {
                tempRecords.levelOfExperienceValidation = true;
                tempRecords.levelofExperianceMessage = 'Please fill Level of Experience';
            } else {
                tempRecords.levelOfExperienceValidation = false;
                tempRecords.levelofExperianceMessage = '';
            }
            if ((tempRecords.dbt__Start_date__c == null || tempRecords.dbt__Start_date__c == '' || tempRecords.dbt__Start_date__c == undefined) &&
                (tempRecords.dbt__Experience__c == null || tempRecords.dbt__Experience__c == '' || tempRecords.dbt__Experience__c == undefined)) {
                tempRecords.experienceValidation = true;
                tempRecords.experienceMessage = 'FIll start date or Experience';
            } else {
                tempRecords.experienceValidation = false;
                tempRecords.experienceMessage = '';
            }

            //Start Date Validation
            if (tempRecords.dbt__Start_date__c !== null && tempRecords.dbt__Start_date__c !== '' && tempRecords.dbt__Start_date__c !== undefined) {
                if (!regex.test(tempRecords.dbt__Start_date__c)) {
                    tempRecords.startDateValidation = true;
                    tempRecords.startDateMessage = 'Format should be MM/YYYY';
                } else if (((parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) > 12) || (parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) < 1)) && (parseInt(tempRecords.dbt__Start_date__c.slice(3, 7)) > currentYear)) {
                    tempRecords.startDateValidation = true;
                    tempRecords.startDateMessage = 'Check month and year';
                } else if ((parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) > 12) || (parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) < 1)) {
                    tempRecords.startDateValidation = true;
                    tempRecords.startDateMessage = 'Fill correct Month';
                } else if (parseInt(tempRecords.dbt__Start_date__c.slice(3, 7)) > currentYear) {
                    tempRecords.startDateValidation = true;
                    tempRecords.startDateMessage = "Year shouldn't be future";
                } else if (parseInt(tempRecords.dbt__Start_date__c.slice(3, 7)) == currentYear) {
                    if (parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) > currentMonth) {
                        tempRecords.startDateValidation = true;
                        tempRecords.startDateMessage = "Fill Correct Month";
                    } else {
                        tempRecords.startDateValidation = false;
                        tempRecords.startDateMessage = '';
                    }
                } else {
                    tempRecords.startDateValidation = false;
                    tempRecords.startDateMessage = '';
                }
            }

            //End Date Validation
            if (tempRecords.dbt__End_date__c !== null && tempRecords.dbt__End_date__c !== '' && tempRecords.dbt__End_date__c !== undefined) {
                if (!regex.test(tempRecords.dbt__End_date__c)) {
                    tempRecords.endDateValidation = true;
                    tempRecords.endDateMessage = 'Format should be MM/YYYY';
                } else if (((parseInt(tempRecords.dbt__End_date__c.slice(0, 2)) > 12) || (parseInt(tempRecords.dbt__End_date__c.slice(0, 2)) < 1)) && (parseInt(tempRecords.dbt__End_date__c.slice(3, 7)) > currentYear)) {
                    tempRecords.endDateValidation = true;
                    tempRecords.endDateMessage = 'Check month and year';
                } else if ((parseInt(tempRecords.dbt__End_date__c.slice(0, 2)) > 12) || (parseInt(tempRecords.dbt__End_date__c.slice(0, 2)) < 1)) {
                    tempRecords.endDateValidation = true;
                    tempRecords.endDateMessage = 'Fill correct Month';
                } else if (parseInt(tempRecords.dbt__End_date__c.slice(3, 7)) > currentYear) {
                    tempRecords.endDateValidation = true;
                    tempRecords.endDateMessage = "Year shouldn't be future";
                } else if (parseInt(tempRecords.dbt__End_date__c.slice(3, 7)) == currentYear) {
                    if (parseInt(tempRecords.dbt__End_date__c.slice(0, 2)) > currentMonth) {
                        tempRecords.endDateValidation = true;
                        tempRecords.endDateMessage = "Fill Correct Month";
                    } else {
                        tempRecords.endDateValidation = false;
                        tempRecords.endDateMessage = '';
                    }
                } else {
                    tempRecords.endDateValidation = false;
                    tempRecords.endDateMessage = '';
                }
            }

            //Start Date and End Date Validation
            if ((tempRecords.dbt__End_date__c !== null && tempRecords.dbt__End_date__c !== '' && tempRecords.dbt__End_date__c !== undefined) &&
                (tempRecords.dbt__Start_date__c !== null && tempRecords.dbt__Start_date__c !== '' && tempRecords.dbt__Start_date__c !== undefined)) {
                if (tempRecords.startDateValidation == false && tempRecords.endDateValidation == false) {
                    if (parseInt(tempRecords.dbt__Start_date__c.slice(3, 7)) > parseInt(tempRecords.dbt__End_date__c.slice(3, 7))) {
                        tempRecords.startDateValidation = true;
                        tempRecords.startDateMessage = "Year shouldn't greater than End year";
                    } else if (parseInt(tempRecords.dbt__Start_date__c.slice(3, 7)) == parseInt(tempRecords.dbt__End_date__c.slice(3, 7))) {
                        if (parseInt(tempRecords.dbt__Start_date__c.slice(0, 2)) > parseInt(tempRecords.dbt__End_date__c.slice(0, 2))) {
                            tempRecords.startDateValidation = true;
                            tempRecords.startDateMessage = "Month shouldn't greater than End month";
                        }
                    } else {
                        tempRecords.startDateValidation = false;
                        tempRecords.startDateMessage = '';
                    }
                }
            }
        }

        for (let i = 0; i < combinedArray.length; i++) {
            console.log('Entered into for loop');
            if (
                combinedArray[i].startDateValidation == false && combinedArray[i].endDateValidation == false
                && combinedArray[i].skillValidation == false && combinedArray[i].levelOfExperienceValidation == false
                && combinedArray[i].experienceValidation == false) {
                finalRecords.push(combinedArray[i]);
            }
        }
        if ((finalRecords.length > 0 && finalRecords.length == combinedArray.length) || this.idToDelete.length > 0) {
            updateSkillResourceRecords({
                jsonOfSkillResourcesUpsert: JSON.stringify(finalRecords), idsToDelete: this.idToDelete
            }).then(data => {
                let event = new ShowToastEvent({
                    message: "Skill-Resources successfully created and Updated!",
                    variant: "success",
                    duration: 2000
                });
                this.dispatchEvent(event);
                this.idToDelete = [];
                this.modifiedDBRecordsId = [];
                return refreshApex(this.wiredSkillResourceResult);
            })
                .catch(error => {
                    this.error = error;
                    let errorMessage = error.body.pageErrors[0].message;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: errorMessage,
                            variant: 'error',
                        }),
                    );
                });
            this.idToDelete = [];
        }
    }
}