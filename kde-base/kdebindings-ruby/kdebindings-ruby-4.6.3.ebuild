# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-ruby/kdebindings-ruby-4.6.3.ebuild,v 1.1 2011/05/07 10:47:38 scarabeus Exp $

EAPI=4

KMNAME="kdebindings"
KMMODULE="ruby"
DECLARATIVE_REQUIRED="optional"
WEBKIT_REQUIRED="optional"

USE_RUBY="ruby18"
# No ruby19 for three reasons:
# 1) it does not build (yet) - will likely be solved soon
# 2) cmake bails when configuring twice or more - solved with CMAKE_IN_SOURCE_BUILD=1
# 3) the ebuild can only be installed for one ruby variant, otherwise the compiled
#    files with identical path+name will overwrite each other - difficult :(

inherit kde4-meta ruby-ng

DESCRIPTION="KDE Ruby bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="akonadi debug kate okular phonon plasma qscintilla qwt semantic-desktop"

DEPEND="
	$(add_kdebase_dep smoke 'akonadi?,declarative?,kate?,okular?,phonon?,qscintilla?,qwt?,semantic-desktop=,webkit?')
"

ruby_add_bdepend dev-ruby/rubygems

RDEPEND="${DEPEND}
	!dev-ruby/qt4-qtruby
"

# Merged with kdebindings-ruby after 4.4.80
add_blocker krossruby

pkg_setup() {
	ruby-ng_pkg_setup
	kde4-meta_pkg_setup
}

src_unpack() {
	local S="${WORKDIR}/${P}"
	kde4-meta_src_unpack

	cd "${WORKDIR}"
	mkdir all
	mv ${P} all/ || die "Could not move sources"
}

all_ruby_prepare() {
	kde4-meta_src_prepare

	sed -i -e "s#smoke/smoke.h#smoke.h#" \
		ruby/qtruby/src/handlers.cpp \
		ruby/qtruby/src/marshall.h \
		ruby/qtruby/src/marshall_types.h \
		ruby/qtruby/src/Qt.cpp \
		ruby/qtruby/src/qtruby.cpp \
		ruby/qtruby/src/qtruby.h \
		ruby/qtruby/src/smokeruby.h || die

	sed -i -e "s#include <smoke/qt/#include <smoke/#" -e "s#include <smoke/kde/#include <smoke/#" \
		ruby/qtruby/src/Qt.cpp \
		ruby/qtruby/src/marshall_types.cpp \
		ruby/qtruby/modules/phonon/phonon.cpp \
		ruby/qtruby/modules/qscintilla/qscintilla.cpp \
		ruby/qtruby/modules/qtdeclarative/qtdeclarative.cpp \
		ruby/qtruby/modules/qtuitools/qtuitools.cpp \
		ruby/qtruby/modules/qtscript/qtscript.cpp \
		ruby/qtruby/modules/qwt/qwt.cpp	\
		ruby/qtruby/modules/qttest/qttest.cpp \
		ruby/qtruby/modules/qtwebkit/qtwebkit.cpp \
		ruby/qtruby/src/qtruby.cpp \
		ruby/korundum/src/Korundum.cpp \
		ruby/korundum/modules/soprano/soprano.cpp \
		ruby/korundum/modules/akonadi/akonadi.cpp \
		ruby/korundum/modules/kate/kate.cpp \
		ruby/korundum/modules/khtml/khtml.cpp \
		ruby/korundum/modules/kio/kio.cpp \
		ruby/korundum/modules/ktexteditor/ktexteditor.cpp \
		ruby/korundum/modules/okular/okular.cpp \
		ruby/korundum/modules/solid/solid.cpp \
		ruby/korundum/modules/nepomuk/nepomuk.cpp \
		ruby/korundum/modules/plasma/src/plasma.cpp \
		ruby/korundum/modules/plasma/src/plasmahandlers.cpp \
		ruby/korundum/modules/nepomuk/nepomukhandlers.cpp || die

	echo 'target_link_libraries(rubyqtdeclarative ${QT_QTDECLARATIVE_LIBRARY})' >> \
		ruby/qtruby/modules/qtdeclarative/CMakeLists.txt || die
}

each_ruby_configure() {
	CMAKE_USE_DIR=${S}
	mycmakeargs=(
		-DRUBY_LIBRARY=$(ruby_get_libruby)
		-DRUBY_INCLUDE_PATH=$(ruby_get_hdrdir)
		-DRUBY_EXECUTABLE=${RUBY}
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_disable kate)
		$(cmake-utils_use_with okular)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with qscintilla QScintilla)
		$(cmake-utils_use_with qwt Qwt5)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_disable webkit QtWebKit)
	)
	kde4-meta_src_configure
}

each_ruby_compile() {
	CMAKE_USE_DIR=${S}
	kde4-meta_src_compile
}

each_ruby_install() {
	CMAKE_USE_DIR=${S}
	kde4-meta_src_install
}
