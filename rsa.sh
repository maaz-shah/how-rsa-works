#!/bin/bash

dashes(){
echo
echo "================================================================================================================================================================="
}


function progress {
 _start=1
 _end=100
 for number in $(seq ${_start} ${_end})
   do
     sleep 0.01
     ProgressBar ${number} ${_end}
   done
     }

function ProgressBar {
  let _progress=(${1}*100/${2}*100)/100
  let _done=(${_progress}*4)/10
  let _left=40-$_done
  # Build progressbar string lengths
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
   printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"


}

function typeeffect
{
    text="$1"
    delay="$2"

    for i in $(seq 0 $(expr length "${text}")) ; do
    echo -n "${text:$i:1}"
    sleep ${delay}
    done
}

function Euclidean()
{
        if [ $2 -eq 0 ]
        then

        return $1

        else

Euclidean $2 $(($1%$2))
# calling function recursively
fi
}

modinverse(){

        n="$1"
        m="$2"
        val=1
        while true
        do
          if [ `expr $val % 10` -eq 0 ]
          then
                printf "."
         fi
        #  mod=`expr $val \* $n`
        #  modu=`expr $mod \% $m`
           modu=$(bc <<< "($val * $n) % $m")
          if [ $modu -eq 1 ]
          then
            return $val
          fi
  let val=val+1
done

}

is_prime(){
 i=2
 while [ $i -lt $num ]
 do
   if [ `expr $num % $i` -eq 0 ]
       then
       return 1
       echo "$num is not a prime number"
       echo "Since it is divisible by $i"
       exit
       fi
       i=`expr $i + 1`
      done
      return 0

   }

echo "Enter prime number 1 "
read prime1

        if [ -z "$prime1" ]
        then
        echo "No arguments supplied"
        exit
        fi


num=$prime1
is_prime
if [ $? -eq 1 ]
  then
  echo "you had to enter a Prime number (This is usually Large number, but you can enter small eg: 11)"
  exit
fi
echo "Enter Prime number 2 "
read prime2
num=$prime2
is_prime

if [ $? -eq 1 ]
  then
    echo "you had to enter a Prime number (This is usually Large number, but you can enter small eg: 13)"
  exit
fi



clear

dashes
typeeffect "The key generation part of the Algorithm seems very simple but is quite complex it creates a pair of private and public RSA key, now what is a Key? Key is simply a number which is generated, and then used in algorithm function the larger number we have the more complex encryption will be, the process of RSA function can be divided into following steps." .05
echo
echo "Now we have 2 prime numbers $prime1 and $prime2"
echo
dashes
echo " Preparing for Key generation"
progress
echo
# Multiply two primes
modulus=`expr $prime1 \* $prime2`
echo
echo "Product of Prime1 and Prime2 = $modulus"
dashes
echo
typeeffect "Generating totient , totient = (prime1 -1 ) *  (prime2 -1) " .1
#Totient
dashes
typeeffect " Calculating totient of two numbers" .1
t1=`expr $prime1 - 1`
t2=`expr $prime2 - 1`
totient=`expr $t1 \* $t2`
echo
echo " Totient is $totient"
dashes
typeeffect " Now we need to find a number whose GCD is 1 with Totient and less than totient" .1
dashes

COUNTER=2
     while [  $COUNTER -lt $totient ]; do
     #echo The counter is $COUNTER
     let num=COUNTER
     let COUNTER=COUNTER+1
     is_prime
     if [ $? -eq 0 ]
     then
        Euclidean $totient $num
        retn_code=$?
        if [ $retn_code -eq 1 ]
        then
           echo " The number with GCD =1 with $totient is $num"
           typeeffect " Therefore your Public Key is $num" .1
           dashes
           break
        fi
     fi
done

e=$num # Public Key

echo
typeeffect " Now for the Private Key we calculate the inverse of public Key with totient" .1
echo
modinverse $e $totient
retn_value=$val
d=$retn_value
dashes
echo
echo " The inverse of $e mod $totient is $retn_value"
echo
echo " This is your private key ' $d ' "
sleep 2

echo " Key generation is complete , your private key is $d and public key is $e "
dashes
echo
echo "Enter a NUMBER to encrypt Make sure the number is less than $d"
read m

typeeffect "Encrypting $m ^ $e Mod $modulus.  .  .  .  .  .  .  . " .1


encr=$(bc <<< "($m ^ $e) % $modulus")

echo " Ecrypted Data = $encr, now this data can be sent easily as this can only be decrypted via private key"
echo
dashes
typeeffect "Now we have to Decrypt the data using the private key" .1
echo
echo " Key $d"
echo " Encrypted message $encr"

typeeffect "Decrypting $encr ^ $d Mod $modulus . . ." .5
echo
echo $pow
decr=$(bc <<< "($encr ^ $d) % $modulus")
echo " Decrypted message = $decr "

echo "END"
