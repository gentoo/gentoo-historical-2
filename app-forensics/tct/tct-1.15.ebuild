# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/tct/tct-1.15.ebuild,v 1.2 2004/09/17 09:56:34 ka0ttic Exp $

inherit eutils

DESCRIPTION="The Coroner's Toolkit - a collection of tools to aide in gathering and analyzing forensic data on a UNIX system"
HOMEPAGE="http://www.porcupine.org/forensics/tct.html"
SRC_URI="http://www.porcupine.org/forensics/${P}.tar.gz"

LICENSE="IBM as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.0004
	>=sys-apps/sed-4"
RDEPEND="${DEPEND}
	dev-perl/DateManip"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e "s:\$(OPT) \$(DEBUG):${CFLAGS}:" */*/Makefile \
		|| die "sed CFLAGS failed"

	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_install() {
	# bins/libs
	into /usr/lib/tct
	dobin bin/* || die "bin installation failed"

	exeinto /usr/lib/tct
	doexe reconfig || die "reconfig installation failed"

	insinto /usr/lib/tct/lib
	doins lib/*.pl || die "lib installation failed"

	exeinto /usr/lib/tct/extras
	doexe extras/bdf extras/ils2mac extras/realpath extras/entropy/entropy \
		extras/findkey/findkey || die "extras installation failed"

	# config
	insinto /etc/tct
	doins conf/* || die "conf installation failed"

	# docs
	newdoc extras/README README.extras || die "newdoc failed"
	dodoc docs/* Beware CHANGES INSTALL OS-NOTES README.FIRST \
		TODO* additional-resources bibliography help-recovering-file \
		help-when-broken-into quick-start || die "doc installation failed"

	rm man/man1/file.1
	rm man/man5/magic.5
	doman man/*/* || die "man installation failed"

	# setup dirs/symlinks
	keepdir /var/log/tct

	dosym /etc/tct /usr/lib/tct/conf || die "dosym failed"

	keepdir /var/lib/tct
	dosym /var/lib/tct /usr/lib/tct/data || die "dosym failed"

	dodir /usr/sbin
	cd ${S}/bin
	# all binaries except the following are meant for internal use
	for bin in grave-robber lazarus mactime unrm; do
		dosym /usr/lib/tct/bin/${bin} /usr/sbin/${bin} \
			|| die "dosym ${bin} failed"
	done
}

pkg_postinst() {
	echo
	einfo "The authors of The Coroner's Toolkit highly recommend"
	einfo "installing sys-apps/lsof for use by the toolkit."
	einfo
	einfo "Please read the README and quickstart files installed"
	einfo "in /usr/share/doc/${PF} before using The Coroner's Toolkit."
	echo
}
