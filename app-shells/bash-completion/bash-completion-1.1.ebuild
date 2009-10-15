# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash-completion/bash-completion-1.1.ebuild,v 1.1 2009/10/15 13:52:35 darkside Exp $

EAPI="2"

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://bash-completion.alioth.debian.org/"
SRC_URI="http://bash-completion.alioth.debian.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect
	|| ( app-shells/bash app-shells/zsh )
	sys-apps/miscfiles"
PDEPEND="app-shells/gentoo-bashcomp"

src_install() {
	emake DESTDIR="${D}" install || die

	dodir /etc/profile.d
	cp "${FILESDIR}/bash-completion.sh" \
		"${D}/etc/profile.d/bash-completion.sh" || die "cp failed"

	dodir /usr/share/bash-completion
	mv "${D}"/etc/bash_completion.d/* "${D}/usr/share/bash-completion/" \
		|| die "installation failed to move files"
	rm -r "${D}"/etc/bash_completion.d || die "rm failed"
	mv "${D}"/etc/bash_completion \
		"${D}/usr/share/bash-completion/.bash-completion" || die "mv failed"
	dodoc AUTHORS README TODO || die "dodocs failes"
}

pkg_postinst() {
	ewarn "There is no more base module. It is always enabled due to"
	ewarn "number of false bugs and ease of maintainership. Please remove"
	ewarn "the base module symlinks that you have."
	elog "Any user can enable the module completions without editing their"
	elog ".bashrc by running:"
	elog
	elog "    eselect bashcomp enable <module>"
	elog
	elog "The system administrator can also be enable this globally with"
	elog
	elog "    eselect bashcomp enable --global <module>"
	elog
	elog "Additional completion modules can be found by running"
	elog
	elog "    eselect bashcomp list"
	elog
	elog "If you use non-login shells you still need to source"
	elog "/etc/profile.d/bash-completion.sh in your ~/.bashrc."

	if has_version 'app-shells/zsh' ; then
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
