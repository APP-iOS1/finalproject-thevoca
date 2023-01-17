
import SwiftUI
import Foundation

struct FRWordsTableView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedSegment: ProfileSection
    @Binding var selectedWord: [UUID]
    
    @Binding var filteredWords: [Word]
    
    @Binding var isShowingEditView: Bool
    @Binding var bindingWord: Word
    
    var backgroundColor: Color = Color("background")
    
    // UIScreen.main deprecated...
    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
    
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                List {
                    ForEach(filteredWords) { word in
                        ZStack {
                            Rectangle()
                                .fill(backgroundColor)
                            VStack {
                                HStack {
                                    Text(word.word ?? "")
                                        .alignmentGuide(
                                            .listRowSeparatorLeading
                                        ) { dimensions in
                                            dimensions[.leading]
                                        }
                                        .frame(width: geo.size.width * 0.5, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .opacity((selectedSegment == .wordTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                                    
                                    HStack {
                                        Image(systemName: word.option == "f" ? "f.square" : "m.square")
                                            .font(.subheadline)
                                            .opacity(0.5)
                                        Text(word.meaning ?? "")
                                    }
                                    .frame(width: geo.size.width * 0.5, alignment: .center)
                                    .multilineTextAlignment(.center)
                                    .opacity((selectedSegment == .meaningTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                                    
                                }
                            }
                        }
                        .contextMenu(ContextMenu {
                            if selectedSegment == .normal {
                                Button {
                                    bindingWord = word
                                    isShowingEditView.toggle()
                                } label: {
                                    Label("수정하기", systemImage: "gearshape.fill")
                                }
                                Button {
                                    // Voice Over
                                } label: {
                                    Label("발음 듣기", systemImage: "mic.fill")
                                }
                            }
                            
                        })
                        .listRowBackground(backgroundColor)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedWord.contains(word.id!) {
                                if let tmpIndex = selectedWord.firstIndex(of: word.id!) {
                                    selectedWord.remove(at: tmpIndex)
                                }
                            } else {
                                selectedWord.append(word.id!)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                word.deletedAt = "\(Date())"
                                print("현재 시간 데이터를 deleteAt prop에 update \(word.deletedAt!)")
                                // filteredWords에서는 진짜로 제거
                                if let index = filteredWords.firstIndex(of: word) {
                                    print("\(index)")
                                    filteredWords.remove(at: index)
                                }
                                try? viewContext.save()
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
//                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
//                            Button {
//                                //word.isMemorized.toggle()
//                                print("Memorize action")
//                            } label: {
//                                Image(systemName: "brain.head.profile")
//                            }
//                            .tint(word.isMemorized ? .gray : .blue)
//                        }
                    }
                    .onMove { indexSet, offset in
                        filteredWords.move(fromOffsets: indexSet, toOffset: offset)
                    }
                    .onDelete { indexSet in
                        // filteredWords에서 지워도 상관없긴 하다.
                        //                    filteredWords.remove(atOffsets: indexSet)
                    }
                }
                .navigationBarItems(trailing: EditButton())
                .refreshable {
                    print("refresh")
                }
                .listStyle(.plain)
            }
            
        }
    }
}
