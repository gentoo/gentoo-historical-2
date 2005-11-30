# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/mldonkey/mldonkey-2.6.0.ebuild,v 1.1 2005/07/23 20:07:48 sekretarz Exp $

inherit eutils

IUSE="X gtk2 gd"

DESCRIPTION="mldonkey is a new client to access the eDonkey network. It is written in Objective-Caml, and comes with its own GTK GUI, an HTTP interface and a telnet interface."
HOMEPAGE="http://www.nongnu.org/mldonkey/"
SRC_URI="http://savannah.nongnu.org/download/mldonkey/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~ia64 ~amd64"

RDEPEND="dev-lang/perl
		net-misc/wget
		>=dev-lang/ocaml-3.08.3
		gtk2? ( >=gnome-base/librsvg-2.4.0
				>=dev-ml/lablgtk-2.4 )
		X? ( !gtk2? ( =dev-ml/lablgtk-1.2.7* ) )
		gd? ( >=media-libs/gd-2.0.28 )"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58"

MLUSER="p2p"

pkg_setup() {
	echo ""
	einfo "If the compile with gui fails, and you have updated ocaml"
	einfo "recently, you may have forgotten that you need to run"
	einfo "/usr/portage/dev-lang/ocaml/files/ocaml-rebuild.sh"
	einfo "to learn which ebuilds you need to recompile"
	einfo "each time you update ocaml to a different version"
	einfo "see the ocaml ebuild for details"
	echo ""
	if use gtk2; then
		built_with_use dev-ml/lablgtk svg || \
	die "dev-ml/lablgtk must be built with the 'svg' USE flag to use the gtk2 gui"
	fi
}

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	export WANT_AUTOCONF=2.5
	cd config; autoconf; cd ..
}

src_compile() {

	econf \
		--sysconfdir=/etc/mldonkey \
		--sharedstatedir=/var/mldonkey \
		--localstatedir=/var/mldonkey \
		--enable-checks \
		--enable-batch \
		--enable-pthread \
		`use_enable gtk2` \
		`use_enable X gui` \
		`use_enable gd` || die "Configure Failed!"

	export OCAMLRUNPARAM="l=256M"
	emake || die "Make Failed"
}

src_install() {
	dobin mlnet
	use gtk && dobin mlchat mlgui mlguistarter mlim mlnet+gui
	dobin ${FILESDIR}/mldonkey

	dodoc ChangeLog Copying.txt Developers.txt Install.txt
	cd ${S}/distrib
	dodoc ChangeLog Authors.txt Bugs.txt Copying.txt Developers.txt Install.txt Readme.txt Todo.txt ed2k_links.txt
	dohtml FAQ.html

	insinto /usr/share/doc/${PF}/scripts
	doins kill_mldonkey mldonkey_command mldonkey_previewer

	insinto /usr/share/doc/${PF}/distrib
	doins directconnect.ini

	cd ${S}/docs
	dodoc *.txt *.tex *.pdf
	dohtml *.html

	cd ${S}/docs/developers
	dodoc *.txt *.tex

	cd ${S}/docs/images
	insinto /usr/share/doc/${PF}/html/images
	doins *

	insinto /etc/conf.d; newins ${FILESDIR}/mldonkey.confd mldonkey
	exeinto /etc/init.d; newexe ${FILESDIR}/mldonkey.initd mldonkey
}

pkg_preinst() {
	enewuser ${MLUSER} -1 /bin/bash /home/p2p users
}

pkg_postinst() {
	echo
	einfo "Running \`mldonkey' will start the server inside ~/.mldonkey/"
	einfo "If you want to start mldonkey in a particular working directory,"
	einfo "use the \`mlnet' command."
	einfo "If you want to start mldonkey as a system service, use"
	einfo "the /etc/init.d/mldonkey script. To control bandwidth, use"
	einfo "the 'slow' and 'fast' arguments. Be sure to have a look at"
	einfo "/etc/conf.d/mldonkey also."
	echo
	einfo "Attention: 2.6 has changed the inifiles structure, so downgrading"
	einfo "will be problematic."
	einfo "User settings (admin) are transferred to users.ini from "
	einfo "downloads.ini"
	einfo "Old ini files are automatically converted to the new format"
	echo
}
