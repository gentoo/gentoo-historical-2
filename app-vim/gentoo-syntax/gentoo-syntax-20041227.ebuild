# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gentoo-syntax/gentoo-syntax-20041227.ebuild,v 1.4 2005/01/13 11:26:13 ciaranm Exp $

inherit eutils vim-plugin

DESCRIPTION="vim plugin: Gentoo Ebuild, Eclass, GLEP, ChangeLog and Portage
Files syntax highlighting, filetype and indent settings"
HOMEPAGE="http://developer.berlios.de/projects/gentoo-syntax"
LICENSE="vim"
KEYWORDS="x86 sparc mips ~amd64 ~ppc ~ppc64 ~alpha ~ia64 ~arm ~hppa ~s390"
SRC_URI="http://download.berlios.de/gentoo-syntax/${P}.tar.bz2"

# For gathering stats. Evil, I know, but I need to know whether I can
# reasonably add this package in as a PDEPEND of vim-core. -- ciaranm
RESTRICT="primaryuri"

IUSE="ignore-glep31"
VIM_PLUGIN_HELPFILES="gentoo-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use ignore-glep31 ; then
		for f in ftplugin/*.vim ; do
			ebegin "Removing UTF-8 rules from ${f} ..."
			sed -i -e 's~\(setlocal fileencoding=utf-8\)~" \1~' ${f} \
				|| die "waah! bad sed voodoo. need more goats."
			eend $?
		done
	fi
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	if use ignore-glep31 1>/dev/null ; then
		ewarn "You have chosen to disable the rules which ensure GLEP 31"
		ewarn "compliance. When editing ebuilds, please make sure you get"
		ewarn "the character set correct."
	else
		einfo "Note for developers and anyone else who edits ebuilds:"
		einfo "    This release of gentoo-syntax now contains filetype rules to set"
		einfo "    fileencoding for ebuilds and ChangeLogs to utf-8 as per GLEP 31."
		einfo "    If you find this feature breaks things, please submit a bug and"
		einfo "    assign it to vim@gentoo.org. You can use the 'ignore-glep31' USE"
		einfo "    flag to remove these rules."
	fi
	echo
	epause 5
}

