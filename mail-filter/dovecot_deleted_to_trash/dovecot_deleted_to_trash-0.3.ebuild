# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dovecot_deleted_to_trash/dovecot_deleted_to_trash-0.3.ebuild,v 1.2 2012/11/10 13:22:26 blueness Exp $

EAPI=4

inherit toolchain-funcs base

DESCRIPTION="Deleted to trash IMAP plugin for Dovecot"
HOMEPAGE="http://wiki.dovecot.org/Plugins/deleted-to-trash"
SRC_URI="http://wiki2.dovecot.org/Plugins/deleted-to-trash?action=AttachFile&do=get&target=deleted-to-trash-plugin_${PV}_for_dovecot_2.tar -> ${P}.tar"

LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"

IUSE=""
RDEPEND="=net-mail/dovecot-2.0*"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}"/fix_names_and_destdir.patch )

S="${WORKDIR}"

src_compile() {
	tc-export CC
	base_src_compile
}

src_install() {
	base_src_install

	insinto /etc/dovecot/conf.d
	doins "${FILESDIR}"/29-delete-to-trash.conf
}
