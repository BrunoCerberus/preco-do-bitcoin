//
//  ViewController.swift
//  Preco do Bitcoin
//
//  Created by Bruno Lopes de Mello on 18/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //define o caminho da API
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            //Define o metodo de requisicao
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
            
                if erro == nil {
                    print("Sucesso ao fazer a consulta")
                    
                    if let dadosRetorno = dados {
                        
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: AnyObject] {
                                if let brl = objetoJson["BRL"] as? [String: AnyObject]{
//                                    print(brl)
                                    if let buy = brl["buy"] as? Double{
                                        let buyFormatado = String(buy).replacingOccurrences(of: ".", with: ",")
                                        print(buyFormatado)
                                    }
                                }
                            }
                        } catch {
                            print("Erro ao formatar retorno")
                        }
                        
                    }
                } else {
                    print("Erro ao fazer a consulta do preco")
                }
            }
            //faz a requisicao
            tarefa.resume()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

