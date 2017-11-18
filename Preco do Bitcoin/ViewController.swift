//
//  ViewController.swift
//  Preco do Bitcoin
//
//  Created by Bruno Lopes de Mello on 18/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var preco: UILabel!
    
    @IBOutlet weak var atualizarButton: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitcoin()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recuperarPrecoBitcoin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func formatarPreco(preco: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let resultado = nf.string(from: preco) {
            return resultado
        }
        return "0,00"
    }

    private func recuperarPrecoBitcoin() {
        
        self.atualizarButton.setTitle("Atualizando...", for: .normal)
        
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
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
                                        if let preco = brl["buy"] as? Double{
                                            let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                            
                                            //so vai alterar o componente de interface assim que o request for concluido
                                            DispatchQueue.main.async(execute: {
                                                self.preco.text = "R$ " + precoFormatado
                                                self.atualizarButton.setTitle("Atualizar", for: .normal)
                                                print(precoFormatado)
                                            })
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

    }
}

