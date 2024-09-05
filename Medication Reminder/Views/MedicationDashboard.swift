//
//  MedicationDashboard.swift
//  Medication Reminder
//
//  Created by Udacity
//

import SwiftUI
import SwiftData

struct MedicationDashboard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [Medication]

    var body: some View {
        NavigationStack { // Note: NavigationStack for hierarchical navigation
            VStack {
                Text("Medication Reminders")
                    .font(.headline)
                List {
                    ForEach(medications) { medication in
                        NavigationLink(destination: EditMedicationView(medication: medication)) {
                            MedicationDashboardRow(medication: medication)
                        }
                    }
                }
                // ... Other dashboard elements...
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EditMedicationView(medication: nil)) { // Create a new Medication
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct MedicationDashboardRow: View {
    @Environment(\.modelContext) private var modelContext

    let medication: Medication
    @State private var isReminderSet: Bool
    
    init(medication: Medication) {
        self.medication = medication
        _isReminderSet = State(initialValue: medication.isReminderSet)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(medication.name)
                    .font(.headline)
                Text("Dosage: \(medication.dosage)")
            }
            Spacer()  // Push elements to the left

            Toggle("", isOn: $isReminderSet)
                .onChange(of: isReminderSet, {
                    isReminderSet.toggle()
                    do {
                        try modelContext.save()
                    } catch {
                        print("isReminder did not save.")
                    }
                })
                .labelsHidden()  // Hide the label for a more compact look
        }
    }


}

#Preview {
    MedicationDashboard()
}


