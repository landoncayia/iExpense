//
//  ContentView.swift
//  iExpense
//
//  Created by Landon Cayia on 6/30/22.
//

import SwiftUI

struct ContentView: View {
    // @StateObject tells SwiftUI to watch the object for any change announcements
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var body: some View {
        NavigationView {
            List {
                // Don't need id because ExpenseItem comforms to Identifiable
                Section(header: Text("Personal Expenses")) {
                    ForEach(expenses.personalExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: currencyFormat)
                                .foregroundColor(item.color)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(item.name), \(Int(floor(item.amount))) dollars and \(Int(round(item.amount.truncatingRemainder(dividingBy: 1)*100))) cents")
                    }
                    .onDelete(perform: { index in removeItems(at: index, section: 0)})
                }
                
                Section(header: Text("Business Expenses")) {
                    ForEach(expenses.businessExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: currencyFormat)
                                .foregroundColor(item.color)
                        }
                    }
                    .onDelete(perform: { index in removeItems(at: index, section: 1)})
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        addSampleExpenses()
                    } label: {
                        Text("Sample")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func removeItems(at offsets: IndexSet, section: Int) {
        guard let index = offsets.first else { return }
        if section == 0 {
            expenses.deleteItem(with: expenses.personalExpenses[index].id)
        } else {
            expenses.deleteItem(with: expenses.businessExpenses[index].id)
        }
    }
    
    func addSampleExpenses() {
        let sampleItem1 = ExpenseItem(name: "Lunch", type: "Personal", amount: 12.0)
        let sampleItem2 = ExpenseItem(name: "Beans", type: "Personal", amount: 3.0)
        let sampleItem3 = ExpenseItem(name: "MacBook Pro", type: "Business", amount: 2400.0)
        expenses.items.append(sampleItem1)
        expenses.items.append(sampleItem2)
        expenses.items.append(sampleItem3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
