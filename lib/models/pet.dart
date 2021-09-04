import 'package:cloud_firestore/cloud_firestore.dart';

class peti {
  final String petType;
  final String petGender;
  final String petName;
  final String petBreed;
  final DateTime petDOB;
  final String petBio;
  final String petLocation;
  final bool pedigree;
  final bool vaccinated;
  final String petId;
  final String ownerId;
  final String url;
  final DateTime RegistrationDate;


  peti({
    this.petType,
    this.petGender,
    this.petName,
    this.petBreed,
    this.petDOB,
    this.petBio,
    this.petLocation,
    this.pedigree,
    this.vaccinated,
    this.petId,
    this.ownerId,
    this.url,
    this.RegistrationDate
  });

  factory peti.fromDocument(DocumentSnapshot doc) {
    return peti(
      petType: doc['PetType'],
      petGender: doc['PetGender'],
      petName: doc['PetName'],
      petBreed: doc['PetBreed'],
      petDOB: doc['DOB'],
      petBio: doc['PetBio'],
      petLocation: doc['PetLocation'],
      pedigree: doc['Pedigree'],
      vaccinated: doc['Vaccinated'],
      petId: doc['petId'],
      ownerId: doc['ownerId'],
      url: doc['url'],
      RegistrationDate: doc['RegistrationDate'],
    );
  }
}
