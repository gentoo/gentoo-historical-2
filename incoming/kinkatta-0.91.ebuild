# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# /home/cvsroot/gentoo-x86/kde-base/kdenetwork/kinkatta-0.91.ebuild v 1 2001/08/29

S=${WORKDIR}/${P}
DESCRIPTION="KDE Aim Clone"
SRC_PATH="kinkatta/${P}.tar.gz"
SRC_URI="http://ftp1.sourceforge.net/$SRC_PATH
	 http://www.research.att.com/~leonb/objprelink/kde-admin-acinclude.patch"

HOMEPAGE="http://www.kde.org"

DEPEND=">=kde-base/kdebase-${PV}
 	objprelink? ( dev-util/objprelink )"

RDEPEND=$DEPEND

src_unpack() {

	cd ${WORKDIR}
	unpack ${P}.tar.gz
	cd ${S}
	use objprelink && patch -p0 < ${DISTDIR}/kde-admin-acinclude.patch

}

src_compile() {
    local myconf
    if [ "`use qtmt`" ]
    then
      myconf="--enable-mt"
    fi
      myconf="$myconf --enable-mitshm"
	if [ "`use objprelink`" ] ; then
	  myconf="$myconf --enable-objprelink"
	fi
    ./configure --host=${CHOST} \
                --with-xinerama $myconf || die
    make || die
}

src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS COPYING README
}
