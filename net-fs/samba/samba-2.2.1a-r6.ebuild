# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-fs/samba/samba-2.2.1a-r6.ebuild,v 1.4 2001/09/09 09:32:13 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Samba :)"
SRC_URI="http://us1.samba.org/samba/ftp/${P}.tar.gz"
HOMEPAGE="http://www.samba.org"

DEPEND="virtual/glibc sys-devel/autoconf
        cups? ( net-print/cups )
        pam? ( >=sys-libs/pam-0.72 )
        tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
        ssl? ( >=dev-libs/openssl-0.9.6 )"

RDEPEND="virtual/glibc cups? ( net-print/cups )"
# PAM support can cause lots of problems. We want the admin of the box to
# do this on his own. There is a mailing list thread on samba-devel that's
# about 40 posts long about this
# pam? ( >=sys-libs/pam-0.72 )"


src_unpack() {

  unpack ${A}
  if [ "`use afs`" ]; then
    cd ${S}
    patch -p0 < ${FILESDIR}/patch.221a.10 || die
  fi

  if [ ! "`use cups`" ] ; then
    cd ${S}/source
    cp configure.in configure.in.orig
    sed -e "s:AC_CHECK_LIB(cups,httpConnect)::" configure.in.orig > configure.in
    autoconf || die
  fi
}


src_compile() { 

  local myconf
  use afs && myconf="$myconf --with-afs"

  # Again same as above, PAM and Samba not good. Consult samba.org for
  # details. Only enable if you KNOW what you're doing and you really really
  # wanna venture down this path.
  # use pam && myconf="${myconf} --with-pam"
  myconf="${myconf} --without-pam"

  # Samba doesn't seem to work well with ssl support but I'll add the check 
  # anyway (otherwise it seems to be built with ssl if it finds it). This should 
  # be tested. I'll mail gentoo-dev and add a todo in wiki. /Hallski
  # use ssl && myconf="${myconf} --with-ssl"
  myconf="${myconf} --without-ssl"
  
  cd ${S}/source
  # Disabled automout support, because it failed
  ./configure --prefix=/usr --sysconfdir=/etc/smb --localstatedir=/var/log \
	--libdir=/etc/smb --sbindir=/usr/sbin --without-automount --with-utmp \
	--without-sambabook --with-netatalk --with-privatedir=/etc/smb/private \
	--with-smbmount --with-msdfs --with-vfs --with-spinlocks \
	--with-lockdir=/var/run/smb --with-swatdir=/usr/share/swat \
	--with-mandir=/usr/share/man --with-profile ${myconf}
  assert
  make || die
}


src_install() { 

  cd ${S}/source
  dodir /usr
  dodir /etc/smb
  dodir /usr/share/swat
  dodir /usr/share/doc/${PF}/html/book
  dodir /var/log
  dodir /var/run/smb

  make install prefix=${D}/usr BASEDIR=${D}/usr PRIVATEDIR=${D}/etc/smb/private \
	LIBDIR=${D}/etc/smb VARDIR=${D}/var/log SWATDIR=${D}/usr/share/swat \
	LOCKDIR=${D}/var/lock SBINDIR=${D}/usr/sbin MANDIR=${D}/usr/share/man || die

  # we specified PRIVATEDIR=/etc/smb/private
  rm -rf ${D}/usr/private
  diropts -m 0700
  dodir /etc/smb/private

  # move smbmount from /usr/sbin to /sbin, and rename it to mount.smbfs
  # which allows it to work transparently with standard 'mount' command
  dodir /sbin
  mv ${D}/usr/bin/smbmount ${D}/sbin/mount.smbfs

  cd ${S}/source/script
  exeinto /usr/sbin
  doexe convert_smbpasswd mknissmbpasswd.sh mknissmbpwdtbl.sh mksmbpasswd.sh smbtar

  # docs. samba has some really good ones.
  cd ${S}
  cp -a examples ${D}/usr/doc/${PF}
  insinto /etc/smb ; newins examples/smb.conf.default smb.conf.example
  insinto /usr/share/sgml/docbook/dbsgml ; doins docs/docbook/dbsgml/*
  insinto /usr/share/sgml/docbook/dbsgml/ent ; doins docs/docbook/dbsgml/ent/*
  dodoc COPYING Manifest README Roadmap WHATSNEW.txt
  cd ${S}/docs ; dodoc announce history samba.lsm THANKS
  docinto reg ; dodoc *.reg
  docinto html ; dodoc htmldocs/*.html
  docinto html/book ; dodoc htmldocs/using_samba/*.html
  docinto html/book/gifs ; dodoc htmldocs/using_samba/gifs/*
  docinto html/book/figs ; dodoc htmldocs/using_samba/figs/*
  docinto faq ; dodoc faq/*.txt
  docinto html/faq ; dodoc faq/*.html
  docinto textdocs ; dodoc textdocs/*.txt textdocs/README*
  docinto print ; dodoc textdocs/*.{tex,ps,pdf} 
  docinto sgml/faq ; dodoc faq/*.sgml
  docinto sgml/docbook/faq ; dodoc docbook/faq/*.sgml
  docinto sgml/docbook/howto ; dodoc docbook/howto/*.sgml	
  docinto sgml/docbook/manpages ; dodoc docbook/manpages/*.sgml
  docinto sgml/docbook/projdoc ; dodoc docbook/projdoc/*.sgml

  exeinto /etc/init.d
  newexe ${FILESDIR}/samba.rc6 samba
}


pkg_preinst() {

  if [ "$ROOT" = "/" ] && [ -e /etc/init.d/samba ] ; then
	if [ -e /dev/shm/.init.d/started/samba ] ; then
		/etc/init.d/samba stop
  	fi
  fi
  return # dont fail
}


pkg_postinst() {

  # we touch ${D}/etc/smb/smb.conf so that people installing samba just to mount smb shares
  # don't get annoying warnings all the time.
  if [ ! -e ${ROOT}etc/smb/smb.conf ] ; then
	touch ${ROOT}etc/smb/smb.conf
  fi

  echo " #"
  echo " If you had samba running earlier, you'll need to start it again. Also, please note"
  echo " that you must configure /etc/smb/smb.conf before samba (the server) will work properly."
  echo " Mounting smb shares and the smbclient program should work immediately.  To accomplish"
  echo " this there is an empty /etc/smb/smb.conf file installed."
  echo
  echo " To mount smb shares, type something like this. You will need kernel SMB support first:"
  echo " % mount -t smbfs -o username=drobbins,password=foo,ip=192.168.1.1 //mybox/drobbins /mnt/foo"
  echo " If you wish to allow normal users to mount smb shares, type the following as root:"
  echo " % chmod u+s /usr/bin/smbmnt"
  echo " #"
}
