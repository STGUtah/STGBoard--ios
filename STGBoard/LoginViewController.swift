//
//  LoginViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
            let email = emailTextField.text else { return }
        
        doesUserExist(email: email) { (person) in
            if let person = person {
                PersonController.shared.save(person: person)
            } else {
                PersonController.shared.addNewPerson(email: email, firstName: firstName, lastName: lastName)
            }
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    private func doesUserExist(email: String, completion: @escaping (_ person: Person?) -> Void) {
        PersonController.shared.getAllPeopleFromServer { (people) in
            if let person = people.filter({ $0.email == email }).first {
                // user exists
                completion(person)
            } else {
                // user doesn't exist yet
                completion(nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
