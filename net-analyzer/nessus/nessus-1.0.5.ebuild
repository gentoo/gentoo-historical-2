#Copyright 2000 Achim Gottinger
#Distributed under the GPL

# It's better to split it in four different packages

A="nessus-libraries-${PV}.tar.gz nessus-core-${PV}.tar.gz
   nessus-plugins-${PV}.tar.gz libnasl-${PV}.tar.gz"
S=${WORKDIR}
DESCRIPTION="A remote security scanner for Linux"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/nessus-libraries-${PV}.tar.gz
	 ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/nessus-core-${PV}.tar.gz
	 ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/nessus-plugins-${PV}.tar.gz
	 ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/libnasl-${PV}.tar.gz"

HOMEPAGE="http://www.nessus.org/"

src_compile() {

  export PATH=${D}/usr/bin:$PATH
  export LD_LIBRARY_PATH=${D}/usr/lib:$LD_LIBRARY_PATH
  echo "Compiling libraries..."                           
  cd ${S}/nessus-libraries
  try ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/state
  try make
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install
  cd ${D}/usr/bin
  cp nessus-config nessus-config.orig
  sed -e "s:^PREFIX=:PREFIX=${D}:" \
      -e "s:-I/usr:-I${D}/usr: " nessus-config.orig > nessus-config

  echo "Compiling libnasl..."
  cd ${S}/libnasl
  try ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/state
  try make
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install
  cd ${D}/usr/bin
  cp nasl-config nasl-config.orig
  sed -e "s:^PREFIX=:PREFIX=${D}:" nasl-config.orig > nasl-config

  echo "Compiling core..."
  cd ${S}/nessus-core
  try ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/state
  try make
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install


  echo "Compiling plugins..."
  cd ${S}/nessus-plugins
  try ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/state
  try make
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install
 
}

src_install() {                               
  cd ${S}/nessus-libraries
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install

  cd ${S}/libnasl
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install

  cd ${S}/nessus-core
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install
  cp ${ROOT}/config/nessusd.conf ${D}/etc/nessus/
 
  cd ${S}/nessus-plugins
  try make prefix=${D}/usr sysconfdir=${D}/etc localstatedir=${D}/var/state install

  cd ${S}/nessus-libraries
  docinto nessus-libraries
  dodoc README* 

  cd ${S}/libnasl
  docinto libnasl
  dodoc COPYING TODO

  cd ${S}/nessus-core
  docinto nessus-core
  dodoc README* UPGRADE_README CHANGES
  dodoc doc/*.txt doc/ntp/*

  cd ${S}/nessus-plugins
  docinto nessus-plugins
  dodoc docs/*.txt plugins/accounts/accounts.txt
  prepman

  insinto /etc/rc.d/init.d
  insopts -m 755
  doins ${FILESDIR}/nessusd
}




