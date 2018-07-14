#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

inline vector<string> split(string text, char d = ','){
    vector<string> result;
    const char *str = text.c_str();

    do {
        string str_d = string("") + d;
        const char *begin = str;
        while(*str != d && *str) ++str;
        string token = string(begin, str);
        if(token.length() && token != str_d)
            result.push_back(string(begin, str));
    } while (0 != *str++);

    return result;
}

inline size_t labelsSubStrEndPos(string line){
    size_t i = 0;
    while (line[i] != ' ' && line[i] != ':' && i < line.length()) ++i;
    if (i >= line.length() && line[i] == ':') return 0;
    else return i;
}

inline string removeFeaturesValues(string line){
    string clean = "";
    size_t i = 0;
    while(i < line.length()){
        while (line[i] != ' ' && i < line.length()) ++i;
        size_t f_s = i;

        while (line[i] != ':' && i < line.length()) ++i;
        size_t f_e = i;

        clean += line.substr(f_s, f_e - f_s);
        if (i >= line.length()) break;
    }
    return clean;
}

int main(int argc, char* argv[]) {

    if (argc < 2) {
        cout << "Not enough arguments.\n";
        exit(1);
    }

    string originalFilePath = string(argv[1]);
    ifstream originalFile;
    originalFile.open(originalFilePath);

    string newFilePath = string(argv[1]);
    ofstream newFile;
    newFile.open(newFilePath + ".ft");

    string line;

    while(getline(originalFile, line)) {
        size_t i = labelsSubStrEndPos(line);
        if(i == 0) continue;

        auto lineLabels = split(line.substr(0,i));
        string lineFeatures = line.substr(i);

        for(auto labelString : lineLabels){
            newFile << "__label__" << labelString << " ";
        }

        newFile << lineFeatures << endl;
    }

    originalFile.close();
    newFile.close();

    exit(0);
}
