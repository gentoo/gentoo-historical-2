# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/howl/howl-0.9.6-r2.ebuild,v 1.1 2004/10/06 23:39:38 latexer Exp $

inherit eutils

DESCRIPTION="Howl is a cross-platform implementation of the Zeroconf networking standard. Zeroconf brings a new ease of use to IP networking."
HOMEPAGE="http://www.porchdogsoft.com/products/howl/"
SRC_URI="http://www.porchdogsoft.com/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~mips"
DEPEND="sys-libs/glibc" # sys-devel/automake - needed if we remove the html docs from /usr/share

src_unpack() {
	unpack ${A}
	sed -i "s:howl-@VERSION@$:howl:" ${S}/howl.pc.in
}

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

	# Install conf files
	insinto /etc/conf.d
	newins ${FILESDIR}/nifd.conf.d nifd
	newins ${FILESDIR}/mDNSResponder.conf.d mDNSResponder

	# Install init scripts
	insinto /etc/init.d
	newins ${FILESDIR}/nifd.init.d nifd
	newins ${FILESDIR}/mDNSResponder.init.d mDNSResponder

	# Fix the perms on the init scripts
	fperms a+x /etc/init.d/nifd /etc/init.d/mDNSResponder

}
