# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.9.ebuild,v 1.2 2002/12/09 04:17:43 manson Exp $

MY_P="${PN}libre-${PV}"
DESCRIPTION="A web-centric format and software platform for distributing documents and images."
HOMEPAGE="http://djvu.sourceforge.net"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc "
IUSE=""
DEPEND=">=qt-3.0.4.20020606-r1
		>=jpeg-6b-r2"

S=${WORKDIR}/${MY_P}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	make depend || die
	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
}

pkg_postinst() {
	# The package installs the browser plugins into
	# /usr/lib/netscape/plugins, so we need to move them to the
	# appropriate mozilla directory. when mozilla is installed.
	if [ -d /usr/lib/mozilla/plugins/ -a \
		 -f /usr/lib/netscape/plugins/nsdejavu.so ]
	then
		cp /usr/lib/netscape/plugins/nsdejavu.so /usr/lib/mozilla/plugins
	fi
}

pkg_postrm() {
	# Maybe we must remove the plugin from the mozilla plugins dir.
	if [ -f /usr/lib/mozilla/plugins/nsdejavu.so ]
	then
		rm /usr/lib/mozilla/plugins/nsdejavu.so 
	fi
}


