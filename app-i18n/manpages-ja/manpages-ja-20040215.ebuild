# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/manpages-ja/manpages-ja-20040215.ebuild,v 1.4 2004/04/03 19:28:07 usata Exp $

IUSE=""

MY_P="man-pages-ja-${PV}"

HOMEPAGE="http://www.linux.or.jp/JM/
	http://www.gentoo.gr.jp/jpmain/translation.xml"
DESCRIPTION="A collection of manual pages translated into Japanese"
SRC_URI="http://www.linux.or.jp/JM/${MY_P}.tar.gz
	http://dev.gentoo.org/~usata/distfiles/portage-${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 alpha ~hppa"
SLOT="0"
S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=">=sys-apps/groff-1.18.1-r2
	=sys-apps/groff-1.18*
	sys-apps/man"

src_install () {

	for x in $(grep '^[^#].*' script/pkgs.list | cut -f1 | sort)
	do
		for a in $(ls -d manual/$x/man* 2>/dev/null)
		do
			jmandir=$(echo $a | cut -d/ -f3)

			einfo install $x:  /usr/share/man/ja/$jmandir/

			insinto /usr/share/man/ja/$jmandir
			doins $a/*
		done
	done

	cd ${WORKDIR}/man
	for y in man[1-9]/*.[1-9]; do
		einfo install ${y##*/}:  /usr/share/man/ja/${y%%/*}/
		insinto /usr/share/man/ja/${y%%/*}
		doins $y
	done
	cd -

	dodoc ChangeLog INSTALL README
}

pkg_postinst () {

	einfo
	einfo "You need to set appropriate LANG and PAGER variables to use"
	einfo "Japanese manpages."
	einfo "e.g."
	einfo "\tLANG=\"ja_JP.eucJP\""
	einfo "\tPAGER=\"jless\""
	einfo "\tJLESSCHARSET=\"ja\""
	einfo "\texport LANG PAGER JLESSCHARSET"
	einfo "or"
	einfo "\tLANG=\"ja_JP.eucJP\""
	einfo "\tPAGER=\"lv -c\""
	einfo "\texport LANG PAGER"
	einfo
}
