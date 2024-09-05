//
//  EditMedicationView.swift
//  Medication Reminder
//
//  Created by Udacity

import SwiftUI
import SwiftData

// a view to edit medication

struct EditMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss // For dismissing the view

    let medication: Medication? // Can be nil when adding new

    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var time: Date = Date()  // Notice: Using Date for time editing

    init(medication: Medication?) {
        self.medication = medication
        // Initialize state variables based on existing Medication if editing
        if let medication = medication {
            _name = State(initialValue: medication.name)
            _dosage = State(initialValue: medication.dosage)
            _time = State(initialValue: Date(timeIntervalSinceReferenceDate: medication.time))
        }
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    DatePicker("Reminder Time", selection: $time, displayedComponents: .hourAndMinute)
                }
                if medication != nil {
                    deleteButton
                }
            }
            
        }
        .navigationTitle(medication == nil ? "Add Medication" : "Edit \(name)")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) { saveButton }
            ToolbarItem(placement: .topBarLeading) { cancelButton }
        }
    }

    private var saveButton: some View {
        Button("Save") {
            saveChanges()
            dismiss()
        }
    }

    private var cancelButton: some View {
        Button("Cancel", role: .cancel) {
            dismiss()
        }
    }
    
    private var deleteButton: some View {
        Button(
            role: .destructive,
            action: {
                delete(medication: medication!)
                dismiss()
            },
            label: {
                Text("Delete")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        )
    }

    private func saveChanges() {
        if let existingMedication = medication {
           // Update existing medication
            existingMedication.name = name
            existingMedication.dosage = dosage
            existingMedication.time = time.timeIntervalSinceReferenceDate
        } else {
            // Create a new medication
            let newMedication = Medication(name: name, 
                                           dosage: dosage,
                                           time: time.timeIntervalSinceReferenceDate
            )
            modelContext.insert(newMedication)
        }

        // Save Context
        do {
            try modelContext.save()
        } catch {
            print("Do something here")
        }
    }
    
    private func delete(medication:Medication) {
        modelContext.delete(medication)
    }
}

#Preview {
    EditMedicationView(medication: Medication.example)
        .modelContainer(for: Medication.self, inMemory: true)
}
