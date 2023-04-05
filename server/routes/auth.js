const express = require("express");
const User = require("../models/user");
const authRouter = express.Router();
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");


//signup
authRouter.post("/api/signup", async (req, res) => {
  try {
    //get data from the client
    const {
      name,
      lastname,
      email,
      password,
      birthday,
      username,
      phone,
      country,
    } = req.body;

    //post that data in database
    const existinguser = await User.findOne({ email });
    if (existinguser) {
      return res
        .status(400)
        .json({ msg: "User with same email is already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
      lastname,
      birthday,
      username,
      phone,
      country
    });

    user = await user.save();
    res.json(user);

    //return the data to the user
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//signin
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password" });
    }

   const token = jwt.sign({id:user._id},"passwordKey");
    res.json({token,...user._doc});
     
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//validate token
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token=req.header("x-auth-token");
    if(!token){
      return res.json(false);
    }

  const verified= jwt.verify(token,"passwordKey");

  if(!verified){
    return res.json(false);
  }
  
  const user = await User.findById(verified.id);

  if(!user){
    return res.json(false);
  }else{
    return res.json(true);
  }
     
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});




//get user data
authRouter.get('/', auth ,async(req,res)=>{
  const user = await User.findById(req.user);
 res.json({...user._doc,token:req.token})
});



// //update password
authRouter.patch('/update/:email',async(req,res)=>{
try {
  await User.findOneAndUpdate({email:req.params.email},{password:req.body.password},{new:true});
  res.json({msg:"password updated successfully"})
} catch (error) {
  console.log(error.toString());
}
})



// otpLogin = async (req, res, next) => {
//   createOtp(req.body, (err, results) => {
//     if (err) {
//       return next(err);
//     }
//     return res.status(200).send({ message: "Success", data: results });
//   });
// };


// otpVerify = async (req, res, next) => {
//   verifyOtp(req.body, (err, results) => {
//     if (err) {
//       return next(err);
//     }
//     return res.status(200).send({ message: "Success", data: results });
//   });
// }

//otp login
// authrouter.post('/otpLogin',otpLogin = async (req, res, next) => {
//   createOtp(req.body, (err, results) => {
//     if (err) {
//       return next(err);
//     }
//     return res.status(200).send({ message: "Success", data: results });
//   });
// });
module.exports = authRouter;
