# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/howl/howl-0.8.3.ebuild,v 1.5 2005/01/09 00:12:47 stkn Exp $

DESCRIPTION="Howl is a cross-platform implementation of the Zeroconf networking standard. Zeroconf brings a new ease of use to IP networking."
HOMEPAGE="http://www.porchdogsoft.com/products/howl/"
SRC_URI="http://www.porchdogsoft.com/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""
DEPEND="sys-libs/glibc" # sys-devel/automake - needed if we remove the html docs from /usr/share
RDEPEND="sys-libs/glibc"

src_compile() {
	# If we wanted to remove the html docs in /usr/share/howl....
	#einfo "Removing html docs from build process...."
	#sed -e 's/ docs//' < Makefile.am > Makefile.am.new || die "sed failed"
	#mv Makefile.am.new Makefile.am || die "move failed"
	#aclocal || die "aclocal failed"
	#automake || die "automake failed"

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dohtml -r docs/

	# nifd service loader
	dodir /etc/conf.d
	cp ${FILESDIR}/nifd.conf.d ${D}/etc/conf.d/nifd || die "cp ${FILESDIR}/nifd.conf.d ${D}/etc/conf.d/nifd"
	dodir /etc/init.d
	cp ${FILESDIR}/nifd.init.d ${D}/etc/init.d/nifd || die "cp ${FILESDIR}/nifd.init.d ${D}/etc/init.d/nifd"
	fperms a+x ${D}/etc/init.d/nifd

	# mDNSResponder service loader
	dodir /etc/conf.d
	cp ${FILESDIR}/mDNSResponder.conf.d ${D}/etc/conf.d/mDNSResponder || die "cp ${FILESDIR}/mDNSResponder.conf.d ${D}/etc/conf.d/mDNSResponder"
	dodir /etc/init.d
	cp ${FILESDIR}/mDNSResponder.init.d ${D}/etc/init.d/mDNSResponder || die "cp ${FILESDIR}/mDNSResponder.init.d ${D}/etc/init.d/mDNSResponder"
	fperms a+x ${D}/etc/init.d/mDNSResponder
}
