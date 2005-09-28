# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/vim-spell.eclass,v 1.1 2005/09/28 18:27:00 ciaranm Exp $

#
# Original Author: Ciaran McCreesh <ciaranm@gentoo.org>
# Maintainers:     Vim Herd <vim@gentoo.org>
# Purpose:         Simplify installing spell files for vim7
#

# How to make a vim spell file package using prebuilt spell lists
# from upstream (${CODE} is the language's two letter code):
#
# * Get the ${CODE}.*.spl and README_${CODE}.txt files. Currently they're
#   at ftp://ftp.vim.org/pub/vim/unstable/runtime/spell/ .
#
# * Stick them in vim-spell-${CODE}-$(date --iso | tr -d - ).tar.bz2 . Make sure
#   that they're in the appropriately named subdirectory to avoid having to mess
#   with S=.
#
# * Upload the tarball to the Gentoo mirrors.
#
# * (for now) Add your spell file to package.mask next to the other vim7
#   things. The vim herd will handle unmasking your spell packages when vim7
#   comes out of package.mask.
#
# * Create the app-vim/vim-spell-${CODE} package. A sample ebuild will look
#   something like (header removed):
#
#     VIM_SPELL_LANGUAGE="French"
#
#     inherit vim-spell
#
#     LICENSE="GPL-2"
#     KEYWORDS="~sparc ~mips"
#     IUSE=""
#
# * Don't forget metadata.xml. You should list vim as the herd, and yourself
#   as the maintainer (there is no need to join the vim herd just for spell
#   files):
#
#     <?xml version="1.0" encoding="UTF-8"?>
#     <!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">
#     <pkgmetadata>
#     	<herd>vim</herd>
#     	<maintainer>
#     		<email>your-name@gentoo.org</email>
#     	</maintainer>
#     	<longdescription lang="en">
#     		Vim spell files for French (fr). Supported character sets are
#     		UTF-8 and latin1.
#     	</longdescription>
#     </pkgmetadata>
#
# * Send an email to vim@gentoo.org to let us know.
#
# Don't forget to update your package as necessary.
#
# If there isn't an upstream-provided pregenerated spell file for your language
# yet, read :help spell.txt from inside vim7 for instructions on how to create
# spell files. It's best to let upstream know if you've generated spell files
# for another language rather than keeping them Gentoo-specific.

EXPORT_FUNCTIONS src_install

IUSE=""
DEPEND="|| ( >=app-editors/vim-7_alpha
	>=app-editors/gvim-7_alpha )"
RDEPEND="${DEPEND}"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
SLOT="0"

if [[ -z "${VIM_SPELL_CODE}" ]] ; then
	VIM_SPELL_CODE="${PN/vim-spell-/}"
fi

if [[ -z "${DESCRIPTION}" ]] ; then
	DESCRIPTION="vim spell files: ${VIM_SPELL_LANGUAGE} (${VIM_SPELL_CODE})"
fi

if [[ -z "${HOMEPAGE}" ]] ; then
	HOMEPAGE="http://www.vim.org/"
fi

vim-spell_src_install() {
	target="/usr/share/vim/vimfiles/spell/"
	dodir "${target}"
	insinto "${target}"

	had_spell_file=
	for f in *.spl ; do
		doins "${f}"
		had_spell_file="yes"
	done

	for f in README* ; do
		dodoc "${f}"
	done

	[[ -z "${had_spell_file}" ]] && die "Didn't install any spell files?"
}

