# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-0.5.9d.ebuild,v 1.3 2000/12/21 08:22:29 achim Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="Advanced Linux Sound Architecture / Drivers"
SRC_URI="ftp://ftp.alsa-project.org/pub/driver/"${A}
HOMEPAGE="http://www.alsa-project.org/"
KERNEL="linux-2.4.0_rc10-r6"
MODULES=2.4.0-test10/kernel/drivers/alsa/
DEPEND=">=sys-kernel/linux-2.4.0_rc10"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr \
	--with-kernel=${WORKDIR}/../../${KERNEL}/work/linux \
	--with-moddir=/lib/modules/${MODULES} \
	--with-isapnp=yes 
  try make
}

src_install() {                               
  cd ${S}
  into /usr
  dosbin snddevices
  insinto /lib/modules/${MODULES}
  doins modules/*.o
  insinto /usr/src/linux/include/linux
  for i in asound asoundid asequencer ainstr_simple ainstr_gf1 ainstr_iw
  do
    doins include/$i.h
  done
  insinto /etc/rc.d/init.d
  doins utils/alsasound
  dodoc COPYING FAQ README WARNING doc/README.1st doc/SOUNDCARDS
}

pkg_postinst() {
    . /etc/rc.d/config/functions
    if [ "${ROOT}" = "/" ] ; then
        echo "Creating sounddevices..."
        /usr/sbin/snddevices
    fi
}




