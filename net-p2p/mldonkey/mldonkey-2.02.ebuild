# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/mldonkey/mldonkey-2.02.ebuild,v 1.1 2002/12/24 13:15:08 bass Exp $

IUSE="gtk"

S=${WORKDIR}/${PN}
# Revision number of the sources
N="0"

DESCRIPTION="edonkey, opennap,... client written in ocaml"
HOMEPAGE="http://www.nongnu.org/mldonkey/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/stable/${P}-${N}.sources.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"

DEPEND="gtk? ( >=lablgtk-1.2.3 )
	>=dev-lang/ocaml-3.06
	sys-devel/perl"

src_compile() {
	use gtk || export GTK_CONFIG="no"

	# the dirs are not (yet) used, but it doesn't hurt to specify them anyway
	econf \
		--sysconfdir=/etc/mldonkey \
		--sharedstatedir=/var/mldonkey \
		--localstatedir=/var/mldonkey

	emake || die
}

src_install() {
	into /usr
	dobin mldonkey mlchat
	for i in mldonkey_gui mldonkey_gui2 mldonkey_guistarter
	do
		if [[ -f ${i} ]]
		then
			dobin ${i}
		fi
	done

	for i in AUTHORS BUGS COPYING ChangeLog Developers.txt ed2k_links.txt \
			 Readme.txt TODO;
	do
		dodoc distrib/${i}
	done

	dohtml FAQ.html

	insinto /usr/share/doc/${PF}/scripts
	for i in kill_mldonkey mldonkey_command mldonkey_previewer;
	do
		doins distrib/${i}
	done

	insinto /usr/share/doc/${PF}/scripts/ed2k_submit
	echo "Ignore CVS error:"
	doins distrib/ed2k_submit/*

	insinto /usr/share/doc/${PF}/distrib
	for i in servers.ini directconnect.ini;
	do
		doins distrib/${i}
	done
}

pkg_postinst() {
	echo
	echo
	einfo "To start mldonkey, copy the contents of \$doc/distrib in a"
	einfo "writable directory, and start mldonkey from there."
	einfo "Eg: cp everything to /home/user1/mldonkey"
	einfo "then: cd /home/user1/mldonkey && mldonkey >> mld.log &"
	echo
	echo
}
