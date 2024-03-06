Class FHIRBundle.BusinessProcess Extends Ens.BusinessProcess
{

Property TargetConfig As Ens.DataType.ConfigName;

Parameter SETTINGS = "TargetConfig";

/// Description
Method OnRequest(pRequest As Ens.StreamContainer, Output pResponse As Ens.StreamContainer) As %Status
{
    Try{
        set tSC = $$$OK
        set tBundle=##class(%DynamicObject).%FromJSON(pRequest.Stream)
        set tEntryIterator = tBundle.entry.%GetIterator()
 
        while tEntryIterator.%GetNext(.tKey,.tVal,.tType) {
            if tVal.resource.resourceType = "Encounter" {
                Set tSC=..ProcessEncounter(.tVal)
            }
 
            if tVal.resource.resourceType = "Immunization" {
                Set tSC=..ProcessImmunization(.tVal)
            }
            if tVal.resource.resourceType = "DiagnosticReport" {
                Set tSC=..ProcessDiagnosticReport(.tVal)
            }
            if tVal.resource.resourceType = "DocumentReference" {
                Set tSC=..ProcessDocumentReference(.tVal)
            }
            if tVal.resource.resourceType = "Claim" {
                Set tSC=..ProcessClaim(.tVal)
            }
            if tVal.resource.resourceType = "ExplanationOfBenefit" {
                Set tSC=..ProcessExplanationOfBenefit(.tVal)
            }
            if tVal.resource.resourceType = "MedicationRequest" {
                Set tSC=..ProcessMedicationRequest(.tVal)
            }
            if tVal.resource.resourceType = "Provenance" {
                Set tSC=..ProcessProvenance(.tVal)
            }
            if tVal.resource.resourceType = "Procedure" {
                Set tSC=..ProcessProcedure(.tVal) 
            }
            if tVal.resource.resourceType = "CareTeam" {
                Set tSC=..ProcessCareTeam(.tVal)
                $$$LOGINFO("Hi.. my code in method 1")
            }
 
		}
 
        set tStream = ##class(%Stream.GlobalCharacter).%New()
        do tStream.Write(tBundle.%ToJSON())
        set tRequest = ##class(Ens.StreamContainer).%New()
        set tRequest.Stream = tStream
        $$$LOGINFO("Hello")
        set tSC = ..SendRequestAsync(..TargetConfig, tRequest, .pResponse)
 
    }
    Catch ex {
    Set tSC=ex.AsStatus()
    }
 
    Quit tSC
}

/// Description
ClassMethod ProcessEncounter(pRequest As %DynamicObject) As %Status
{
    Try {
        set tSC = $$$OK
        set tPatIterator = pRequest.resource.participant.%GetIterator()
        while tPatIterator.%GetNext(.tPatKey, .tPatVal, .tPatType) {
 
            if tPatVal.individual.reference["Practitioner?identifier=" {
                set tPatVal.individual.reference = "Practitioner/17"
                set tPatVal.individual.display = "Dr. Elvin140 Marks830"
            }
        }
        if pRequest.resource.serviceProvider.reference]"Organization?identifier=" {
        Set pRequest.resource.serviceProvider.reference = "Organization/17"
        Set pRequest.resource.serviceProvider.display = "BEDFORD-LEXINGTON INTERNAL MEDICINE, PC"
        }
 
        set tLocIterator = pRequest.resource.location.%GetIterator()
        while tLocIterator.%GetNext(.tLocKey, .tLocVal, .tLocType)
        {
            if tLocVal.location.reference]"Location?identifier=" {
                set tLocVal.location.reference = "Location/5045"
            }
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
 
    Return tSC
}

ClassMethod ProcessImmunization(pRequest As %DynamicObject) As %Status
{
 
    Try {
 
        Set tSC = $$$OK
 
        If pRequest.resource.location.reference["Location?identifier=" {
 
            Set pRequest.resource.location.reference = "Location/5093"
 
            }
        }
 
    Catch ex {
 
        Set tSC = ex.AsStatus()
 
        // Handle the exception here, e.g., log the error
 
        Write "An error occurred: ", ex.Name, ": ", ex.Message
 
    }
 
    Quit tSC
}

ClassMethod ProcessDiagnosticReport(pRequest As %DynamicObject) As %Status
{
 
    Try {
 
        Set tSC = $$$OK
        set tPerIterator = pRequest.resource.performer.%GetIterator()
        while tPerIterator.%GetNext(.tPerKey, .tPerVal, .tPerType) {
 
            if tPerVal.reference["Organization?identifier=" {
                set tPerVal.reference = "Organization/17"
            }
            if tPerVal.reference["Practitioner?identifier=" {
                set tPerVal.reference = "Practitioner/17"
                set tPerVal.display = "Dr. Elvin140 Marks830"
            }
        }
 
    }
 
    Catch ex {
 
        Set tSC = ex.AsStatus()
    }
 
    Quit tSC
}

ClassMethod ProcessDocumentReference(pRequest As %DynamicObject) As %Status
{
 
    Try {
 
        Set tSC = $$$OK
        set tautIterator = pRequest.resource.author.%GetIterator()
        while tautIterator.%GetNext(.tautKey, .tautVal, .tautType) {
 
            if tautVal.reference["Practitioner?identifier=" {
                set tautVal.reference = "Practitioner/17"
                set tautVal.display = "Dr. Elvin140 Marks830"
            }
        }
        if pRequest.resource.custodian.reference["Organization?identifier=" {
            set pRequest.resource.custodian.reference = "Organization/17"
        }
 
    }
 
    Catch ex {
 
        Set tSC = ex.AsStatus()
    }
 
    Quit tSC
}

ClassMethod ProcessClaim(pRequest As %DynamicObject) As %Status
{
 
    Try {
 
        Set tSC = $$$OK
        If pRequest.resource.provider.reference["Organization?identifier=" {
 
            Set pRequest.resource.provider.reference = "Organization/17"
            }
        If pRequest.resource.facility.reference["Location?identifier=" {
 
            Set pRequest.resource.facility.reference = "Location/5093"
 
            }        
        }
 
    Catch ex {
 
        Set tSC = ex.AsStatus()
        // Handle the exception here, e.g., log the error
 
        Write "An error occurred: ", ex.Name, ": ", ex.Message
 
    }
    Quit tSC
}

ClassMethod ProcessExplanationOfBenefit(pRequest As %DynamicObject) As %Status
{
    Try {
        Set tSC = $$$OK
        set texpIterator = pRequest.resource.contained.%GetIterator()
        while texpIterator.%GetNext(.texpKey, .texpVal, .texpType) {
 
            if texpVal.resourceType = "ServiceRequest" {
                set tSC = ..ProcessServiceRequest(.texpVal)
 
            }
        If pRequest.resource.provider.reference]"Practitioner?identifier=" {
            set pRequest.resource.provider.reference = "Practitioner/17"
 
        }
        if pRequest.resource.provider.reference]"Organization?identifier=" {
            Set pRequest.resource.provider.reference = "Organization/17"
        }
        If pRequest.resource.facility.reference]"Location?identifier=" {
            set pRequest.resource.facility.reference = "Location/5093"
 
        }
        set tcarIterator = pRequest.resource.careTeam.%GetIterator()
        while tcarIterator.%GetNext(.tcarKey, .tcarVal, .tcarType) {
            if tcarVal.provider.reference["Practitioner?identifier=" {
                set tcarVal.provider.reference = "Practitioner/17"
            }
            if tcarVal.provider.reference]"Organization?identifier=" {
                Set tcarVal.provider.reference = "Organization/17"
            }
        }
        }
    }
    Catch ex {
 
        Set tSC = ex.AsStatus()
    }
    Quit tSC
}

/// Description
ClassMethod ProcessServiceRequest(pRequest As %DynamicObject) As %Status
{
    Try {
 
        Set tSC = $$$OK
        If pRequest.requester.reference["Practitioner?identifier=" {
            set pRequest.requester.reference = "Practitioner/17"
 
        }
        set tperIterator = pRequest.performer.%GetIterator()
        while tperIterator.%GetNext(.tperKey, .tperVal, .tperType) {
            if tperVal.reference["Practitioner?identifier=" {
                set tperVal.reference = "Practitioner/17"
            }
        }   
    }
 
    Catch ex {
        Set tSC = ex.AsStatus()
        // Handle the exception here, e.g., log the error
        Write "An error occurred: ", ex.Name, ": ", ex.Message
 
    }
    Quit tSC
}

/// Description
ClassMethod ProcessMedicationRequest(pRequest As %DynamicObject) As %Status
{
    Try {
        Set tSC = $$$OK
 
        If pRequest.resource.requester.reference["Practitioner?identifier=" {
            set pRequest.resource.requester.reference = "Practitioner/17"
 
        }
    }
 
    Catch ex {
 
        Set tSC = ex.AsStatus()
        // Handle the exception here, e.g., log the error
        Write "An error occurred: ", ex.Name, ": ", ex.Message
 
    }
 
    Quit tSC
}

/// Description
ClassMethod ProcessProvenance(pRequest As %DynamicObject) As %Status
{
    Try {
        Set tSC = $$$OK
        set tagentIterator = pRequest.resource.agent.%GetIterator()
        while tagentIterator.%GetNext(.tagentKey, .tagentVal, .tagentType) {
            If tagentVal.who.reference["Practitioner?identifier=" {
                set tagentVal.who.reference = "Practitioner/17"
            }
            If tagentVal.onBehalfOf.reference["Organization?identifier=" {
                set tagentVal.onBehalfOf.reference = "Organization/17"
             }
        }
    }
    Catch ex {
 
        Set tSC = ex.AsStatus()
 
        // Handle the exception here, e.g., log the error
        Write "An error occurred: ", ex.Name, ": ", ex.Message
    }
 
    Quit tSC
}

/// Description
ClassMethod ProcessProcedure(pRequest As %DynamicObject) As %Status
{
    Try {
        Set tSC = $$$OK
        If pRequest.resource.location.reference["Location?identifier=" {
            Set pRequest.resource.location.reference = "Location/5093"
 
            }
    }
    Catch ex {
 
        Set tSC = ex.AsStatus()
        // Handle the exception here, e.g., log the error
        Write "An error occurred: ", ex.Name, ": ", ex.Message
 
    }
 
    Quit tSC
}

ClassMethod ProcessCareTeam(pRequest As %DynamicObject) As %Status
{
    Try {
        Set tSC = $$$OK
        set tparIterator = pRequest.resource.participant.%GetIterator()
        while tparIterator.%GetNext(.tparKey, .tparVal, .tparType) {
            If tparVal.member.reference["Practitioner?identifier=" {
                set tparVal.member.reference = "Practitioner/17"
            }
            If tparVal.member.reference["Organization?identifier=" {
                set tparVal.member.reference = "Organization/17"
             }
        }
        set tmanIterator = pRequest.resource.managingOrganization.%GetIterator()
        while tmanIterator.%GetNext(.tmanKey, .tmanVal, .tmanType) {
            If tmanVal.reference["Organization?identifier=" {
                set tmanVal.reference = "Organization/17"
            }
        }
    }
    Catch ex {
 
        Set tSC = ex.AsStatus()
        // Handle the exception here, e.g., log the error
        Write "An error occurred: ", ex.Name, ": ", ex.Message
    }
 
    Quit tSC
}

/// Description
/// Description
Storage Default
{
<Data name="BusinessProcessDefaultData1">
<Subscript>"BusinessProcess"</Subscript>
<Value name="1">
<Value>TargetConfig</Value>
</Value>
</Data>
<DefaultData>BusinessProcessDefaultData1</DefaultData>
<Description>
<![CDATA[Description
Description]]></Description>
<Type>%Storage.Persistent</Type>
}

}
