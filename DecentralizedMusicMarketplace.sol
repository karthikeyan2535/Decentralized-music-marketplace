// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; //using solidity version 0.8.17
import "@openzeppelin/contracts/utils/Counters.sol"; // importing counters library from openzeppelin to keep track of the ids
contract DecentralizedMusicMarketplace{
    // defining a structure for songs
    struct Song{
        uint id;    //unique id for the songs
        uint price; //price of the song in eth
        string name; //name of the song
        address payable artist; //address of the artist
        uint hash; //unique hash to prevent duplicates
    }
    //defining a structure for Artists
    struct Artist{
    bool registered; 
    address payable artist; // As the artist recieves ether the address is payable
    Song[] uploaded; //Array to store songs uploaded by the artist
    }
    //defining a structure for listeners
    struct Listeners{
    bool registered;
    address listener;
    mapping(uint => bool) purchasedSongs; // maps song IDs to check if they are purchased or not
    }
    //Using an array to store all the uploaded songs
    Song[] songs;
     mapping (address=>Artist) artists; // maps artist addresses to the Artist details structure
     mapping (address=>Listeners) listeners;//maps Listener addresses to the listeners details structure
     mapping (uint => bool) songshash; // maps hash values to avoid any duplicates
     using Counters for Counters.Counter; 
     Counters.Counter private songsID; // using counters imported from openzeppelin to keep track of songIds
     //Events to emit in console 
     event newArtistRegistered(address artist); 
     event newListenerRegistered(address listener);
     event SongUploaded(uint id, address artist, string name, uint price);
     event SongPurchased(uint id,address Listener,string name,uint price);
     event DonationMade(address Listener,address to,uint amount);
    constructor(){
    }
    //function to register an artist
    function registerArtist() public {
    require(artists[msg.sender].registered==false,"Artist Already registered");//checks if the artist already exists
    artists[msg.sender].registered=true;   //sets the values accordingly
    listeners[msg.sender].registered=true; // as an artist registered is also a listener by default
    artists[msg.sender].artist=payable(msg.sender);
    listeners[msg.sender].listener=msg.sender;
    emit newArtistRegistered(msg.sender); //emits an event that a new artist has registered
    }
    function registerListener() public {
    require(listeners[msg.sender].registered==false,"Listener Already registered"); //checks if the listener already registered
    listeners[msg.sender].registered=true;   //sets values accordingly
    listeners[msg.sender].listener=msg.sender;
    emit newListenerRegistered(msg.sender); //emits an event that a new listener has registered
    }
    //modifier which accepts only artists to access functions
    modifier artistsonly() {
    require(artists[msg.sender].registered, "Not a registered artist");
    _;
}
//modifier which accepts only registered users to access functions
modifier listenersonly() {
    require(listeners[msg.sender].registered, "Not registered");
    _;
}
// function to upload a song
    function UploadSong(uint price,string memory name) public artistsonly { //as only an owner can upload a song
        uint songhash=uint(keccak256(abi.encodePacked(name,msg.sender))); //generates a unique hash for every song to prevent duplicates
        require(!songshash[songhash], "Song with this name already uploaded by you"); //Checks for duplicates and reverts if any
        songsID.increment(); //incrementing the counter value
        uint newid=songsID.current();
        Song memory newSong = Song({ //creating a new song with the given details
        id:newid,
        price: price,
        name: name,
        artist: payable (msg.sender),
        hash:uint8(songhash) //typecasting the hash value so that song details dont look clumsy
    }
        );
    songs.push(newSong); // adding the new song to the array
    artists[msg.sender].uploaded.push(newSong); //adding the song in the artists uploaded array
    songshash[songhash]=true; //marking the songs existence true
    emit SongUploaded(newid,msg.sender,name,price); //emits an event that a new song is uploaded
    }
    // modifier to check if song exists
    modifier songexistence(uint id){ 
        require(id <= songsID.current(), "Song does not exist");//song of that id must exist
        _;
    }
    //function for the listeners to perchase the song
    function PurchaseSong(uint id) public payable listenersonly songexistence(id){ // as only the registered listeners can purchase
        Song memory s=songs[id - 1];
        require(msg.value>=s.price,"Insufficient");
        require(!listeners[msg.sender].purchasedSongs[id], "Song already purchased");
        uint overpay = msg.value - s.price; //stores the amount that is overpayed
        if (overpay > 0) {
        (bool success, ) = msg.sender.call{value: overpay}(""); //sends back the overpaid ether as we're good people
        require(success, "Transfer failed"); 
        }
        s.artist.transfer(s.price);    //transfers ether from the listener to the owners address
        listeners[msg.sender].purchasedSongs[id]=true; //marks the song as purchased
        emit SongPurchased(id,msg.sender, s.name,s.price); //emits and event that the song is purchased
    }
    //function for the listeners to donate funds
    function Donate(uint id,uint amt) public payable listenersonly songexistence(id){
        require(msg.value==amt,"You dont have enough amount");
        songs[id - 1].artist.transfer(amt); //transfers amount from the listener to the owners address
        emit DonationMade(msg.sender, songs[id - 1].artist,amt); //emits an event that the donation is made
    }
    //function to get the song details by song ID for listeners to browse
    function getSong(uint id) public view  listenersonly songexistence(id) returns (uint, string memory, uint, address){
        return (songs[id - 1].id, songs[id - 1].name, songs[id - 1].price, songs[id - 1].artist);
    }
    //function to get all the uploaded songs for listeners to browse
    function getAllSongs() public view listenersonly returns (Song[] memory) {
        return songs;
    }
    //function to get the purchased songs by the listener
    function getPurchasedSongs() public view listenersonly returns (Song[] memory) {
        uint count = 0; //keeps count of the number of purchased songs
        for (uint i = 0; i < songsID.current(); i++) {
            if (listeners[msg.sender].purchasedSongs[i + 1]) {
                count++;
            }
        }
        Song[] memory purchasedSongs = new Song[](count); //array initialized to return the purchased songs list
        uint index = 0;
        for (uint i = 0; i < songsID.current(); i++) { //stores the purchased songs in the array
            if (listeners[msg.sender].purchasedSongs[i + 1]) {
                purchasedSongs[index] = songs[i];
                index++;
            }
        }
        return purchasedSongs; //returns the purchsed songs list
    }
}
