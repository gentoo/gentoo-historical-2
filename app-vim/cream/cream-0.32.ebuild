# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cream/cream-0.32.ebuild,v 1.12 2007/07/11 05:14:08 mr_bones_ Exp $

inherit vim-plugin eutils

DESCRIPTION="Cream is an easy-to-use configuration of the GVim text editor"
HOMEPAGE="http://cream.sourceforge.net"

DICT_EN="eng_2.0.2"
DICT_FR="fre_2.1"
DICT_ES="spa_3.0"
DICT_DE="ger_2.0.1"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	linguas_en? ( ${HOMEPAGE}/cream-spell-dict-${DICT_EN}.zip )
	linguas_fr? ( ${HOMEPAGE}/cream-spell-dict-${DICT_FR}.zip )
	linguas_es? ( ${HOMEPAGE}/cream-spell-dict-${DICT_ES}.zip )
	linguas_de? ( ${HOMEPAGE}/cream-spell-dict-${DICT_DE}.zip )"

IUSE="linguas_en linguas_fr linguas_es linguas_de"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc mips amd64 alpha ia64"

DEPEND="app-arch/unzip"
RDEPEND=">=app-editors/gvim-6.2
	dev-util/ctags"

VIM_PLUGIN_HELPTEXT=\
"Cream is completely independent from the rest of your Vim/GVim setup.
To launch GVim in Cream mode, use this wrapper script:
\    % cream [filename...]

Cream's documentation has been installed in ${ROOT}usr/share/doc/${PF}
In particular, you may want to read:

\ - the Cream features list:
file://${ROOT}usr/share/doc/${PF}/html/features.html

\ - the Cream shortcuts list:
file://${ROOT}usr/share/doc/${PF}/html/keyboardshortcuts.html

\ - the Cream FAQ:
file://${ROOT}usr/share/doc/${PF}/html/faq.html"

src_unpack() {
	mkdir -p ${S}/spelldicts

	# install spell dictionaries into ${S}/spelldicts
	local my_a
	for my_a in ${A} ; do
		if [ -z ${my_a/*spell-dict*/} ] ; then
			cd ${S}/spelldicts
			unpack ${my_a}
		else
			cd ${WORKDIR}
			unpack ${my_a}
		fi
	done

	# change installation path + fix the wrapper command (disable plugins)
	cd ${S}
	cat >cream <<EOF
#!/bin/sh
gvim --noplugin -U NONE -u "\\\$VIM/cream/creamrc" "\$@"
EOF
	sed -i "/let \$CREAM/s:VIMRUNTIME:VIM:" creamrc || die "sed #1 broke"

	# make taglist ebuild aware, bug #66052
	epatch ${FILESDIR}/${PN}-0.30-ebuilds.patch
}

src_install() {
	# install launcher and menu entry
	dobin cream
	insinto /usr/share/applications
	doins cream.desktop
	insinto /usr/share/icons
	doins cream.svg cream.png

	# install shared vim files
	insinto /usr/share/vim/cream
	doins *.vim creamrc
	local dir
	for dir in addons bitmaps spelldicts filetypes ; do
		cp -R ${dir} ${D}/usr/share/vim/cream
	done
	dodir /usr/share/vim/vimfiles
	cp -R help ${D}/usr/share/vim/vimfiles/doc

	# install docs
	dodoc docs/*
	dohtml docs-html/*
}

pkg_setup() {
	elog "Cream comes with several dictionaries for spell checking. In"
	elog "all cases, at least a small English dictionary will be installed."
	elog
	elog "To specify which optional dictionaries are installed, set the"
	elog "LINGUAS variable in /etc/make.conf. For example, to install full"
	elog "English and French dictionaries, use:"
	elog "    LINGUAS=\"en fr\""
	elog
	elog "Available dictionaries are:"
	for dict in "English en" "French fr" "German de" "Spanish es" ; do
		# portage bug: shouldn't get a QA notice for linguas stuff...
		elog "    ${dict% *} \t(${dict#* }) $( ( \
			use linguas_${dict#* } &>/dev/null && \
			echo '(Will be installed)' ) || echo '(Will not be installed)' )"
	done
	elog
	# give the user time to cancel if necessary
	epause
}
