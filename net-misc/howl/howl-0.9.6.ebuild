# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/howl/howl-0.9.6.ebuild,v 1.3 2004/08/18 20:54:16 eradicator Exp $

inherit eutils

DESCRIPTION="Howl is a cross-platform implementation of the Zeroconf networking standard. Zeroconf brings a new ease of use to IP networking."
HOMEPAGE="http://www.porchdogsoft.com/products/howl/"
SRC_URI="http://www.porchdogsoft.com/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
DEPEND="sys-libs/glibc" # sys-devel/automake - needed if we remove the html docs from /usr/share

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
	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
	dohtml -r docs/

	# doesn't work right now.
	# nifd service loader
	#dodir /etc/conf.d
	#cp ${FILESDIR}/nifd.conf.d ${D}/etc/conf.d/nifd || die "cp nifd.conf.d"
	#dodir /etc/init.d
	#cp ${FILESDIR}/nifd.init.d ${D}/etc/init.d/nifd || die "cp nifd.init.d"
	#fperms a+x ${D}/etc/init.d/nifd

	# mDNSResponder service loader
	insinto /etc/conf.d
	newins ${FILESDIR}/mDNSResponder.conf.d mDNSResponder || die "cp mDNSResponder.conf.d"
	insinto /etc/init.d
	newins ${FILESDIR}/mDNSResponder.init.d mDNSResponder || die "cp mDNSResponder.init.d"
	fperms a+x /etc/init.d/mDNSResponder
}
